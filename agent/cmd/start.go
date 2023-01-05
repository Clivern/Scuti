// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package cmd

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/clivern/scuti/agent/core/controller"
	"github.com/clivern/scuti/agent/core/service"

	"github.com/drone/envsubst"
	"github.com/labstack/echo-contrib/prometheus"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	log "github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var agentCmd = &cobra.Command{
	Use:   "start",
	Short: "Start the scuti agent",
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

		if viper.GetString("agent.log.output") != "stdout" {
			dir, _ := filepath.Split(viper.GetString("agent.log.output"))

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
			if !fys.FileExists(viper.GetString("agent.log.output")) {
				f, err := os.Create(viper.GetString("agent.log.output"))
				if err != nil {
					panic(fmt.Sprintf(
						"Error while creating log file [%s]: %s",
						viper.GetString("agent.log.output"),
						err.Error(),
					))
				}
				defer f.Close()
			}
		}

		defaultLogger := middleware.DefaultLoggerConfig

		if viper.GetString("agent.log.output") == "stdout" {
			log.SetOutput(os.Stdout)
			defaultLogger.Output = os.Stdout
		} else {
			f, _ := os.OpenFile(
				viper.GetString("agent.log.output"),
				os.O_APPEND|os.O_CREATE|os.O_WRONLY,
				0775,
			)
			log.SetOutput(f)
			defaultLogger.Output = f
		}

		lvl := strings.ToLower(viper.GetString("agent.log.level"))
		level, err := log.ParseLevel(lvl)

		if err != nil {
			level = log.InfoLevel
		}

		log.SetLevel(level)

		if viper.GetString("agent.log.format") == "json" {
			log.SetFormatter(&log.JSONFormatter{})
		} else {
			log.SetFormatter(&log.TextFormatter{})
		}

		viper.SetDefault("config", config)

		if viper.GetString("agent.telemetry.status") == "enabled" {

			log.WithFields(log.Fields{
				"name": viper.GetString("agent.name"),
			}).Info(`Starting the agent ...`)

			// Run Worker
			go controller.Worker()

			e := echo.New()

			if viper.GetString("agent.mode") == "dev" {
				e.Debug = true
			}

			e.Use(middleware.LoggerWithConfig(defaultLogger))
			e.Use(middleware.RequestID())
			e.Use(middleware.BodyLimit("2M"))
			e.Use(middleware.TimeoutWithConfig(middleware.TimeoutConfig{
				Timeout: time.Duration(viper.GetInt("agent.timeout")) * time.Second,
			}))

			p := prometheus.NewPrometheus(viper.GetString("agent.name"), nil)

			p.Use(e)

			e.GET("/favicon.ico", func(c echo.Context) error {
				return c.String(http.StatusNoContent, "")
			})

			e.GET("/", controller.HealthAction)

			var runerr error

			if viper.GetBool("agent.telemetry.tls.status") {
				runerr = e.StartTLS(
					fmt.Sprintf(":%s", strconv.Itoa(viper.GetInt("agent.telemetry.port"))),
					viper.GetString("agent.telemetry.tls.crt_path"),
					viper.GetString("agent.telemetry.tls.key_path"),
				)
			} else {
				runerr = e.Start(
					fmt.Sprintf(":%s", strconv.Itoa(viper.GetInt("agent.telemetry.port"))),
				)
			}

			if runerr != nil && runerr != http.ErrServerClosed {
				panic(runerr.Error())
			}

		} else {
			log.WithFields(log.Fields{
				"name": viper.GetString("agent.name"),
			}).Info(`Starting the agent`)

			// Run Worker
			controller.Worker()
		}
	},
}

func init() {
	agentCmd.Flags().StringVarP(
		&config,
		"config",
		"c",
		"agent.config.prod.yml",
		"Absolute path to config file (required)",
	)
	agentCmd.MarkFlagRequired("config")
	rootCmd.AddCommand(agentCmd)
}
