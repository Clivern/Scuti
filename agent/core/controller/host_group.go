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

// GetHostGroupsAction Controller
func GetHostGroupsAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to GetHostGroups Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	objects := globalContext.GetDatabase().GetHostGroupsByTeam(currentUser.TID)

	output := make(map[string]interface{})
	groups := []map[string]interface{}{}

	for _, group := range objects {
		entity := map[string]interface{}{
			"id":        group.ID,
			"uuid":      group.UUID,
			"name":      group.Name,
			"teamId":    group.TID,
			"apiKey":    group.ApiKey,
			"labels":    group.Labels,
			"meta":      group.Meta,
			"createdAt": group.CreatedAt,
			"updatedAt": group.UpdatedAt,
		}

		groups = append(groups, entity)
	}

	output["groups"] = groups

	return c.JSON(http.StatusOK, output)
}

// GetHostGroupAction Controller
func GetHostGroupAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to GetHostGroup Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	uuid := c.Param("uuid")

	group := globalContext.GetDatabase().GetHostGroupByUUID(uuid)

	if group.IsNil() {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"errorMessage": fmt.Sprintf("Host Group with UUID %s not found", uuid),
		})
	}

	if currentUser.TID != group.TID {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"errorMessage": "Unauthorized Access",
		})
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"id":        group.ID,
		"uuid":      group.UUID,
		"name":      group.Name,
		"teamId":    group.TID,
		"apiKey":    group.ApiKey,
		"labels":    group.Labels,
		"meta":      group.Meta,
		"createdAt": group.CreatedAt,
		"updatedAt": group.UpdatedAt,
	})
}

// CreateHostGroupAction Controller
func CreateHostGroupAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to CreateHostGroup Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	data, err := GetRequestData(c)

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "Error! Invalid request",
		})
	}

	rules := map[string]interface{}{
		"name":   "required,min=2,max=60",
		"labels": "required,min=0,max=100",
	}

	errors := map[string]string{
		"name":   "Host group name is required and must be between 2 and 60 characters long.",
		"labels": "Host group labels must be between 0 and 100 characters long.",
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

	group := globalContext.GetDatabase().CreateHostGroup(&model.HostGroup{
		TID:    currentUser.TID,
		UUID:   util.GetUUID4(),
		Name:   data["name"],
		ApiKey: util.GetUUID4(),
		Labels: data["labels"],
		Meta:   "{}",
	})

	return c.JSON(http.StatusCreated, map[string]interface{}{
		"id":        group.ID,
		"uuid":      group.UUID,
		"name":      group.Name,
		"teamId":    group.TID,
		"apiKey":    group.ApiKey,
		"labels":    group.Labels,
		"meta":      group.Meta,
		"createdAt": group.CreatedAt,
		"updatedAt": group.UpdatedAt,
	})
}

// UpdateHostGroupAction Controller
func UpdateHostGroupAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to UpdateHostGroup Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	uuid := c.Param("uuid")

	group := globalContext.GetDatabase().GetHostGroupByUUID(uuid)

	if group.IsNil() {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"errorMessage": fmt.Sprintf("Host Group with UUID %s not found", uuid),
		})
	}

	if currentUser.TID != group.TID {
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
		"name":   "required,min=2,max=60",
		"labels": "required,min=0,max=100",
	}

	errors := map[string]string{
		"name":   "Host group name is required and must be between 2 and 60 characters long.",
		"labels": "Host group labels must be between 0 and 100 characters long.",
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

	group.Name = data["name"]
	group.Labels = data["labels"]

	globalContext.GetDatabase().UpdateHostGroup(&group)

	return c.JSON(http.StatusOK, map[string]interface{}{
		"id":        group.ID,
		"uuid":      group.UUID,
		"name":      group.Name,
		"teamId":    group.TID,
		"apiKey":    group.ApiKey,
		"labels":    group.Labels,
		"meta":      group.Meta,
		"createdAt": group.CreatedAt,
		"updatedAt": group.UpdatedAt,
	})
}

// DeleteHostGroupAction Controller
func DeleteHostGroupAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to DeleteHostGroup Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	uuid := c.Param("uuid")

	hostGroup := globalContext.GetDatabase().GetHostGroupByUUID(uuid)

	if hostGroup.IsNil() {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"errorMessage": fmt.Sprintf("Host Group with UUID %s not found", uuid),
		})
	}

	if hostGroup.TID != currentUser.TID {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"errorMessage": "Unauthorized Access",
		})
	}

	globalContext.GetDatabase().DeleteHostGroupByUUID(uuid)

	return c.NoContent(http.StatusNoContent)
}
