// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package controller

import (
	"fmt"
	"net/http"
	"time"

	"github.com/clivern/mandrill/core/model"
	"github.com/clivern/mandrill/core/util"

	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
)

// AuthAction Controller
func AuthAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to Auth Action`)

	data, err := GetRequestData(c)

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "Error! Invalid request",
		})
	}

	option := globalContext.GetDatabase().GetOptionByKey("app_name")

	if option.IsNil() {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "Error! Application is not installed yet.",
		})
	}

	rules := map[string]interface{}{
		"email":    "required,email,max=100",
		"password": "required,min=5,max=20",
	}

	errors := map[string]string{
		"email":    "Invalid email or password",
		"password": "Invalid email or password",
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

	user := globalContext.GetDatabase().GetUserByEmail(data["email"])

	if user.IsNil() {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "Error! Invalid email or password",
		})
	}

	if !globalContext.GetDatabase().ValidatePassword(data["password"], user.PasswordHash) {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "Error! Invalid email or password",
		})
	}

	log.Info(`Cleanup expired or user old sessions`)

	// Cleanup expired and user sessions
	globalContext.GetDatabase().RemoveExpiredSessions()
	globalContext.GetDatabase().RemoveUserSessions(user.ID)

	// Create a new session
	session := globalContext.GetDatabase().CreateSession(&model.Session{
		UID:       user.ID,
		UUID:      util.GetUUID4(),
		Value:     util.GetUUID4(),
		Meta:      "{}",
		CanExpire: "no",
		ExpiredAt: time.Now(),
	})

	if session.IsNil() {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"errorMessage": "Internal Server Error!",
		})
	}

	log.WithFields(log.Fields{
		"user_id":    user.ID,
		"session_id": session.ID,
	}).Info(`Create a new session`)

	return c.JSON(http.StatusOK, map[string]interface{}{
		"user_id":      user.ID,
		"user_uuid":    user.UUID,
		"email":        user.Email,
		"name":         user.Name,
		"role":         user.Role,
		"api_key":      session.Value,
		"session_id":   session.ID,
		"session_uuid": session.UUID,
	})
}
