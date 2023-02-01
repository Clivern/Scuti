// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package controller

import (
	"fmt"
	"net/http"
	"strconv"

	"github.com/clivern/mandrill/core/model"
	"github.com/clivern/mandrill/core/util"

	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
)

// GetUsersAction Controller
func GetUsersAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to GetUsers Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	objects := globalContext.GetDatabase().GetUsers()

	if currentUser.Role != "super" {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"errorMessage": "Unauthorized Access",
		})
	}

	output := make(map[string]interface{})
	users := []map[string]interface{}{}

	for _, user := range objects {
		entity := map[string]interface{}{
			"id":        user.ID,
			"uuid":      user.UUID,
			"teamId":    user.TID,
			"name":      user.Name,
			"email":     user.Email,
			"status":    user.Status,
			"role":      user.Role,
			"createdAt": user.CreatedAt,
			"updatedAt": user.UpdatedAt,
		}

		users = append(users, entity)
	}

	output["users"] = users

	return c.JSON(http.StatusOK, output)
}

// GetUserAction Controller
func GetUserAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to GetUser Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	uuid := c.Param("uuid")

	user := globalContext.GetDatabase().GetUserByUUID(uuid)

	if user.IsNil() {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"errorMessage": fmt.Sprintf("User with UUID %s not found", uuid),
		})
	}

	if currentUser.Role != "super" {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"errorMessage": "Unauthorized Access",
		})
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"id":        user.ID,
		"uuid":      user.UUID,
		"teamId":    user.TID,
		"name":      user.Name,
		"email":     user.Email,
		"status":    user.Status,
		"role":      user.Role,
		"createdAt": user.CreatedAt,
		"updatedAt": user.UpdatedAt,
	})
}

// CreateUserAction Controller
func CreateUserAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to CreateUser Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	if currentUser.Role != "super" {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"errorMessage": "Unauthorized Access",
		})
	}

	data, err := GetRequestData(c)

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "Error! Invalid request",
		})
	}

	rules := map[string]interface{}{
		"user_name":     "required,min=2,max=20",
		"user_email":    "required,email,max=100",
		"user_status":   "required,min=2,max=20",
		"user_role":     "required,min=2,max=20",
		"user_password": "required,min=5,max=20",
		"team_id":       "required,number",
	}

	errors := map[string]string{
		"user_name":     "User name is required and must be between 2 and 20 characters long.",
		"user_email":    "User email is required and must be a valid email.",
		"user_status":   "User status is required.",
		"user_role":     "User role is required.",
		"team_id":       "User team is required.",
		"user_password": "User password is required and must between 5 and 20 characters long.",
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

	passwordHash, err := globalContext.GetDatabase().GeneratePasswordHash(data["user_password"])

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "Error! Admin password is required",
		})
	}

	teamId, err := strconv.Atoi(data["team_id"])

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "Error! Team is required",
		})
	}

	user := globalContext.GetDatabase().CreateUser(&model.User{
		TID:          teamId,
		UUID:         util.GetUUID4(),
		Name:         data["user_name"],
		Email:        data["user_email"],
		PasswordHash: passwordHash,
		Status:       data["user_status"],
		Role:         data["user_role"],
		Meta:         "{}",
	})

	return c.JSON(http.StatusCreated, map[string]interface{}{
		"id":        user.ID,
		"uuid":      user.UUID,
		"name":      user.Name,
		"email":     user.Email,
		"status":    user.Status,
		"role":      user.Role,
		"meta":      user.Meta,
		"createdAt": user.CreatedAt,
		"updatedAt": user.UpdatedAt,
	})
}

// UpdateUserAction Controller
func UpdateUserAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to UpdateUser Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	uuid := c.Param("uuid")

	user := globalContext.GetDatabase().GetUserByUUID(uuid)

	if user.IsNil() {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"errorMessage": fmt.Sprintf("User with UUID %s not found", uuid),
		})
	}

	if currentUser.Role != "super" {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"errorMessage": "Unauthorized Access",
		})
	}

	data, err := GetRequestData(c)

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "Error! Invalid request",
		})
	}

	rules := map[string]interface{}{
		"user_name":   "required,min=2,max=20",
		"user_email":  "required,email,max=100",
		"user_status": "required,min=2,max=20",
		"user_role":   "required,min=2,max=20",
		"team_id":     "required,min=2,max=20",
	}

	errors := map[string]string{
		"user_name":   "User name is required.",
		"user_email":  "User email is required.",
		"user_status": "User status is required.",
		"user_role":   "User role is required.",
		"team_id":     "Team ID is required.",
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

	return c.JSON(http.StatusOK, map[string]interface{}{
		"id":        user.ID,
		"uuid":      user.UUID,
		"name":      user.Name,
		"email":     user.Email,
		"status":    user.Status,
		"role":      user.Role,
		"meta":      user.Meta,
		"createdAt": user.CreatedAt,
		"updatedAt": user.UpdatedAt,
	})
}

// DeleteUserAction Controller
func DeleteUserAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to DeleteUser Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	uuid := c.Param("uuid")

	user := globalContext.GetDatabase().GetUserByUUID(uuid)

	if user.IsNil() {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"errorMessage": fmt.Sprintf("User with UUID %s not found", uuid),
		})
	}

	if user.ID == currentUser.ID {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "User can't delete his account",
		})
	}

	if currentUser.Role != "super" {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"errorMessage": "Unauthorized Access",
		})
	}

	globalContext.GetDatabase().DeleteUserByUUID(uuid)

	return c.NoContent(http.StatusNoContent)
}
