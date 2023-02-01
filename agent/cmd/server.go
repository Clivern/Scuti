// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package cmd

import (
	"bytes"
	"fmt"
	"io/fs"
	"io/ioutil"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/clivern/mandrill/core/controller"
	mid "github.com/clivern/mandrill/core/middleware"
	"github.com/clivern/mandrill/core/module"
	"github.com/clivern/mandrill/core/service"

	"github.com/drone/envsubst"
	"github.com/labstack/echo-contrib/prometheus"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	log "github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var serverCmd = &cobra.Command{
	Use:   "server",
	Short: "Start the mandrill backend server",
	Run: func(cmd *cobra.Command, args []string) {
		configUnparsed, err := ioutil.ReadFile(config)

		if err != nil {
			panic(fmt.Sprintf(
				"Error while reading config file [%s]: %s",
				config,
				err.Error(),
			))
		}

		configParsed, err := envsubst.EvalEnv(string(configUnparsed))

		if err != nil {
			panic(fmt.Sprintf(
				"Error while parsing config file [%s]: %s",
				config,
				err.Error(),
			))
		}

		viper.SetConfigType("yaml")
		err = viper.ReadConfig(bytes.NewBuffer([]byte(configParsed)))

		if err != nil {
			panic(fmt.Sprintf(
				"Error while loading configs [%s]: %s",
				config,
				err.Error(),
			))
		}

		fys := service.NewFileSystem()

		if viper.GetString("server.log.output") != "stdout" {
			dir, _ := filepath.Split(viper.GetString("server.log.output"))

			// Create dir
			if !fys.DirExists(dir) {
				if err := fys.EnsureDir(dir, 0775); err != nil {
					panic(fmt.Sprintf(
						"Directory [%s] creation failed with error: %s",
						dir,
						err.Error(),
					))
				}
			}

			// Create log file if not exists
			if !fys.FileExists(viper.GetString("server.log.output")) {
				f, err := os.Create(viper.GetString("server.log.output"))
				if err != nil {
					panic(fmt.Sprintf(
						"Error while creating log file [%s]: %s",
						viper.GetString("server.log.output"),
						err.Error(),
					))
				}
				defer f.Close()
			}
		}

		defaultLogger := middleware.DefaultLoggerConfig

		if viper.GetString("server.log.output") == "stdout" {
			log.SetOutput(os.Stdout)
			defaultLogger.Output = os.Stdout
		} else {
			f, _ := os.OpenFile(
				viper.GetString("server.log.output"),
				os.O_APPEND|os.O_CREATE|os.O_WRONLY,
				0775,
			)
			log.SetOutput(f)
			defaultLogger.Output = f
		}

		lvl := strings.ToLower(viper.GetString("server.log.level"))
		level, err := log.ParseLevel(lvl)

		if err != nil {
			level = log.InfoLevel
		}

		log.SetLevel(level)

		if viper.GetString("server.log.format") == "json" {
			log.SetFormatter(&log.JSONFormatter{})
		} else {
			log.SetFormatter(&log.TextFormatter{})
		}

		context := &controller.GlobalContext{
			Database: &module.Database{},
		}

		err = context.GetDatabase().AutoConnect()

		if err != nil {
			panic(err.Error())
		}

		// Migrate Database
		success := context.GetDatabase().Migrate()

		if !success {
			panic("Error! Unable to migrate database tables.")
		}

		defer context.GetDatabase().Close()

		viper.SetDefault("config", config)

		e := echo.New()
		e.Pre(middleware.RemoveTrailingSlash())

		if viper.GetString("server.mode") == "dev" {
			e.Debug = true
		}

		e.Use(mid.Logger)
		e.Use(middleware.LoggerWithConfig(defaultLogger))
		e.Use(middleware.RequestID())
		e.Use(middleware.BodyLimit("2M"))
		e.Use(middleware.CORS())
		e.Use(middleware.Gzip())
		e.Use(middleware.Recover())
		e.Use(middleware.Secure())
		e.Use(middleware.TimeoutWithConfig(middleware.TimeoutConfig{
			Timeout: time.Duration(viper.GetInt("server.timeout")) * time.Second,
		}))

		p := prometheus.NewPrometheus(viper.GetString("server.name"), nil)

		p.Use(e)

		e.GET("/favicon.ico", func(c echo.Context) error {
			return c.String(http.StatusNoContent, "")
		})

		dist, err := fs.Sub(Static, "web/dist")

		if err != nil {
			panic(fmt.Sprintf(
				"Error while accessing dist files: %s",
				err.Error(),
			))
		}

		staticServer := http.StripPrefix("/", http.FileServer(http.FS(dist)))

		e.GET("/health", controller.HealthAction)
		e.GET("/ready", func(c echo.Context) error {
			return controller.ReadyAction(c, context)
		})

		// Authenticate Endpoint
		e.POST("/action/auth", func(c echo.Context) error {
			return controller.AuthAction(c, context)
		})

		// Install Endpoint
		e.POST("/action/install", func(c echo.Context) error {
			return controller.InstallAction(c, context)
		})

		// API Protected Routes
		e1 := e.Group("/api/v1")
		{
			e1.Use(middleware.KeyAuthWithConfig(middleware.KeyAuthConfig{
				KeyLookup:  "header:x-api-key",
				AuthScheme: "",
				Validator: func(key string, c echo.Context) (bool, error) {
					if !strings.Contains(c.Request().URL.Path, "/api/v1/") {
						return true, nil
					}

					user := context.CurrentUser(key)

					if !user.IsNil() {
						log.WithFields(log.Fields{
							"api_key":   key,
							"user_id":   user.ID,
							"user_uuid": user.UUID,
						}).Info(`Authorized Access`)
					} else {
						log.WithFields(log.Fields{
							"api_key": key,
						}).Info(`Unauthorized Access`)
					}

					return !user.IsNil(), nil
				},
			}))

			// Dashboard
			e1.GET("/dashboard", func(c echo.Context) error {
				return controller.DashboardAction(c, context)
			})

			// List Teams
			e1.GET("/team", func(c echo.Context) error {
				return controller.GetTeamsAction(c, context)
			})

			// Get Team
			e1.GET("/team/:uuid", func(c echo.Context) error {
				return controller.GetTeamAction(c, context)
			})

			// Create Team
			e1.POST("/team", func(c echo.Context) error {
				return controller.CreateTeamAction(c, context)
			})

			// Update Team
			e1.PUT("/team/:uuid", func(c echo.Context) error {
				return controller.UpdateTeamAction(c, context)
			})

			// Delete Team
			e1.DELETE("/team/:uuid", func(c echo.Context) error {
				return controller.DeleteTeamAction(c, context)
			})

			// List Users
			e1.GET("/user", func(c echo.Context) error {
				return controller.GetUsersAction(c, context)
			})

			// Get User
			e1.GET("/user/:uuid", func(c echo.Context) error {
				return controller.GetUserAction(c, context)
			})

			// Create User
			e1.POST("/user", func(c echo.Context) error {
				return controller.CreateUserAction(c, context)
			})

			// Update User
			e1.PUT("/user/:uuid", func(c echo.Context) error {
				return controller.UpdateUserAction(c, context)
			})

			// Delete User
			e1.DELETE("/user/:uuid", func(c echo.Context) error {
				return controller.DeleteUserAction(c, context)
			})

			// List Deployments
			e1.GET("/deployment", func(c echo.Context) error {
				return controller.GetDeploymentsAction(c, context)
			})

			// Get Deployment
			e1.GET("/deployment/:uuid", func(c echo.Context) error {
				return controller.GetDeploymentAction(c, context)
			})

			// Create Deployment
			e1.POST("/deployment", func(c echo.Context) error {
				return controller.CreateDeploymentAction(c, context)
			})

			// Update Deployment
			e1.PUT("/deployment/:uuid", func(c echo.Context) error {
				return controller.UpdateDeploymentAction(c, context)
			})

			// Delete Deployment
			e1.DELETE("/deployment/:uuid", func(c echo.Context) error {
				return controller.DeleteDeploymentAction(c, context)
			})

			// List Hosts
			e1.GET("/host", func(c echo.Context) error {
				return controller.GetHostsAction(c, context)
			})

			// Get Host
			e1.GET("/host/:uuid", func(c echo.Context) error {
				return controller.GetHostAction(c, context)
			})

			// Create Host
			e1.POST("/host", func(c echo.Context) error {
				return controller.CreateHostAction(c, context)
			})

			// Update Host
			e1.PUT("/host/:uuid", func(c echo.Context) error {
				return controller.UpdateHostAction(c, context)
			})

			// Delete Host
			e1.DELETE("/host/:uuid", func(c echo.Context) error {
				return controller.DeleteHostAction(c, context)
			})

			// List Host Groups
			e1.GET("/host-group", func(c echo.Context) error {
				return controller.GetHostGroupsAction(c, context)
			})

			// Get Host Group
			e1.GET("/host-group/:uuid", func(c echo.Context) error {
				return controller.GetHostGroupAction(c, context)
			})

			// Create Host Group
			e1.POST("/host-group", func(c echo.Context) error {
				return controller.CreateHostGroupAction(c, context)
			})

			// Update Host Group
			e1.PUT("/host-group/:uuid", func(c echo.Context) error {
				return controller.UpdateHostGroupAction(c, context)
			})

			// Delete Host Group
			e1.DELETE("/host-group/:uuid", func(c echo.Context) error {
				return controller.DeleteHostGroupAction(c, context)
			})

			// Get Task
			e1.GET("/task/:uuid", func(c echo.Context) error {
				return controller.GetTaskAction(c, context)
			})

			// Delete Task
			e1.DELETE("/task/:uuid", func(c echo.Context) error {
				return controller.DeleteTaskAction(c, context)
			})

			// List Activities
			e1.GET("/activity", func(c echo.Context) error {
				return controller.GetActivitiesAction(c, context)
			})

			// Delete Activity
			e1.DELETE("/activity/:uuid", func(c echo.Context) error {
				return controller.DeleteActivityAction(c, context)
			})

			// Agent Heartbeat
			e.POST("/heartbeat", func(c echo.Context) error {
				return controller.HeartbeatAction(c, context)
			})
		}

		// UI Routes
		e.GET("/*", echo.WrapHandler(staticServer))

		var runerr error

		if viper.GetBool("server.tls.status") {
			runerr = e.StartTLS(
				fmt.Sprintf(":%s", strconv.Itoa(viper.GetInt("server.port"))),
				viper.GetString("server.tls.crt_path"),
				viper.GetString("server.tls.key_path"),
			)
		} else {
			runerr = e.Start(
				fmt.Sprintf(":%s", strconv.Itoa(viper.GetInt("server.port"))),
			)
		}

		if runerr != nil && runerr != http.ErrServerClosed {
			panic(runerr.Error())
		}
	},
}

func init() {
	serverCmd.Flags().StringVarP(
		&config,
		"config",
		"c",
		"config.prod.yml",
		"Absolute path to config file (required)",
	)
	serverCmd.MarkFlagRequired("config")
	rootCmd.AddCommand(serverCmd)
}
