// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package controller

import (
	"fmt"
	"net/http"

	"github.com/clivern/mandrill/core/model"
	"github.com/clivern/mandrill/core/util"

	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
)

// InstallAction Controller
func InstallAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to Install Action`)

	data, err := GetRequestData(c)

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "Error! Invalid request",
		})
	}

	option := globalContext.GetDatabase().GetOptionByKey("app_name")

	if !option.IsNil() {
		log.Info(`Application is already installed`)

		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "Error! Application is already installed",
		})
	}

	rules := map[string]interface{}{
		"app_name":       "required,min=2,max=20",
		"app_url":        "required,url,max=100",
		"app_email":      "required,email,max=100",
		"admin_name":     "required,min=2,max=20",
		"admin_email":    "required,email,max=100",
		"admin_password": "required,min=5,max=20",
	}

	errors := map[string]string{
		"app_name":       "App name is required and must be between 2 and 20 characters long.",
		"app_url":        "App URL is required and must be a valid URL.",
		"app_email":      "Admin email is required and must be a valid email.",
		"admin_name":     "Admin name is required and must be between 2 and 20 characters long.",
		"admin_email":    "Admin email is required and must be a valid email.",
		"admin_password": "Admin password is required and must between 5 and 20 characters long.",
	}

	intMp := make(map[string]interface{})

	for key, value := range data {
		intMp[key] = value
	}

	log.Info(`Validate the incoming request data`)

	validate := validator.New()

	errs := validate.ValidateMap(intMp, rules)

	if len(errs) > 0 {
		for inputName := range errs {
			return c.JSON(http.StatusBadRequest, map[string]interface{}{
				"errorMessage": fmt.Sprintf("Error! %s", errors[inputName]),
			})
		}
	}

	passwordHash, err := globalContext.GetDatabase().GeneratePasswordHash(data["admin_password"])

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "Error! Admin password is required",
		})
	}

	log.Info(`Store application data`)

	op1 := globalContext.GetDatabase().CreateOption(&model.Option{
		Key:   "app_name",
		Value: data["app_name"],
		UUID:  util.GetUUID4(),
	})

	if op1.IsNil() {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"errorMessage": "Internal Server Error!",
		})
	}

	op2 := globalContext.GetDatabase().CreateOption(&model.Option{
		Key:   "app_url",
		Value: data["app_url"],
		UUID:  util.GetUUID4(),
	})

	if op2.IsNil() {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"errorMessage": "Internal Server Error!",
		})
	}

	op3 := globalContext.GetDatabase().CreateOption(&model.Option{
		Key:   "app_email",
		Value: data["app_email"],
		UUID:  util.GetUUID4(),
	})

	if op3.IsNil() {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"errorMessage": "Internal Server Error!",
		})
	}

	team := globalContext.GetDatabase().CreateTeam(&model.Team{
		UUID: util.GetUUID4(),
		Name: "sudoers",
		Meta: "{}",
	})

	if team.IsNil() {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"errorMessage": "Internal Server Error!",
		})
	}

	user := globalContext.GetDatabase().CreateUser(&model.User{
		UUID:         util.GetUUID4(),
		TID:          team.ID,
		Name:         data["admin_name"],
		Email:        data["admin_email"],
		PasswordHash: passwordHash,
		Status:       "enabled",
		Role:         "super",
		Meta:         "{}",
	})

	if user.IsNil() {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"errorMessage": "Internal Server Error!",
		})
	}

	log := globalContext.GetDatabase().CreateLog(&model.Log{
		TID:   team.ID,
		UUID:  util.GetUUID4(),
		Value: fmt.Sprintf("User with email %s installed Mandrill", data["admin_email"]),
		Meta:  "{}",
	})

	if log.IsNil() {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"errorMessage": "Internal Server Error!",
		})
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"successMessage": "Application installed successfully",
	})
}
