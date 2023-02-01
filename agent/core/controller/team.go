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

// GetTeamsAction Controller
func GetTeamsAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to GetTeams Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	objects := globalContext.GetDatabase().GetTeams()

	if currentUser.Role != "super" {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"errorMessage": "Unauthorized Access",
		})
	}

	output := make(map[string]interface{})
	teams := []map[string]interface{}{}

	for _, team := range objects {
		entity := map[string]interface{}{
			"id":        team.ID,
			"uuid":      team.UUID,
			"name":      team.Name,
			"createdAt": team.CreatedAt,
			"updatedAt": team.UpdatedAt,
		}

		teams = append(teams, entity)
	}

	output["teams"] = teams

	return c.JSON(http.StatusOK, output)
}

// GetTeamAction Controller
func GetTeamAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to GetTeam Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	if currentUser.Role != "super" {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"errorMessage": "Unauthorized Access",
		})
	}

	uuid := c.Param("uuid")

	team := globalContext.GetDatabase().GetTeamByUUID(uuid)

	if team.IsNil() {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"errorMessage": fmt.Sprintf("Team with UUID %s not found", uuid),
		})
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"id":        team.ID,
		"uuid":      team.UUID,
		"name":      team.Name,
		"createdAt": team.CreatedAt,
		"updatedAt": team.UpdatedAt,
	})
}

// CreateTeamAction Controller
func CreateTeamAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to CreateTeam Action`)

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
		"team_name": "required,min=2,max=20",
	}

	errors := map[string]string{
		"team_name": "Team name is required and must be between 2 and 20 characters long.",
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

	team := globalContext.GetDatabase().CreateTeam(&model.Team{
		Name: "team_name",
		Meta: "{}",
		UUID: util.GetUUID4(),
	})

	return c.JSON(http.StatusCreated, map[string]interface{}{
		"id":        team.ID,
		"uuid":      team.UUID,
		"name":      team.Name,
		"createdAt": team.CreatedAt,
		"updatedAt": team.UpdatedAt,
	})
}

// UpdateTeamAction Controller
func UpdateTeamAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to UpdateTeam Action`)

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
		"team_name": "required,min=2,max=20",
	}

	errors := map[string]string{
		"team_name": "Team name is required and must be between 2 and 20 characters long.",
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

	uuid := c.Param("uuid")

	team := globalContext.GetDatabase().GetTeamByUUID(uuid)

	if team.IsNil() {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"errorMessage": fmt.Sprintf("Team with UUID %s not found", uuid),
		})
	}

	team.Name = data["team_name"]

	team = globalContext.GetDatabase().UpdateTeam(team)

	return c.JSON(http.StatusOK, map[string]interface{}{
		"id":        team.ID,
		"uuid":      team.UUID,
		"name":      team.Name,
		"createdAt": team.CreatedAt,
		"updatedAt": team.UpdatedAt,
	})
}

// DeleteTeamAction Controller
func DeleteTeamAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to DeleteTeam Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	if currentUser.Role != "super" {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"errorMessage": "Unauthorized Access",
		})
	}

	uuid := c.Param("uuid")

	team := globalContext.GetDatabase().GetTeamByUUID(uuid)

	if team.IsNil() {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"errorMessage": fmt.Sprintf("Team with UUID %s not found", uuid),
		})
	}

	if team.ID == currentUser.TID {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "User can't delete his team",
		})
	}

	globalContext.GetDatabase().DeleteTeamByUUID(uuid)

	return c.NoContent(http.StatusNoContent)
}
