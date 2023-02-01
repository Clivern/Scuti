// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package controller

import (
	"fmt"
	"net/http"
	"strconv"

	"github.com/clivern/mandrill/core/model"

	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
)

// GetActivitiesAction Controller
func GetActivitiesAction(c echo.Context, globalContext *GlobalContext) error {
	var logs []model.Log

	log.Info(`Incoming Request to GetActivities Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	host, _ := strconv.Atoi(c.QueryParam("host"))
	deployment, _ := strconv.Atoi(c.QueryParam("deployment"))
	host_group, _ := strconv.Atoi(c.QueryParam("host_group"))

	if host != 0 {
		logs = globalContext.GetDatabase().GetLogsByHost(host, currentUser.TID)
	} else if deployment != 0 {
		logs = globalContext.GetDatabase().GetLogsByDeployment(deployment, currentUser.TID)
	} else if host_group != 0 {
		logs = globalContext.GetDatabase().GetLogsByHostGroup(host_group, currentUser.TID)
	} else {
		logs = globalContext.GetDatabase().GetLogsByTeam(currentUser.TID)
	}

	output := make(map[string]interface{})
	activities := []map[string]interface{}{}

	for _, log := range logs {
		activity := map[string]interface{}{
			"id":        log.ID,
			"uuid":      log.UUID,
			"activity":  log.Value,
			"createdAt": log.CreatedAt,
			"updatedAt": log.UpdatedAt,
		}

		activities = append(activities, activity)
	}

	output["activities"] = activities

	return c.JSON(http.StatusOK, output)
}

// DeleteActivityAction Controller
func DeleteActivityAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to DeleteActivity Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	uuid := c.Param("uuid")

	activity := globalContext.GetDatabase().GetLogByUUID(uuid)

	if activity.IsNil() {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"errorMessage": fmt.Sprintf("Activity with UUID %s not found", uuid),
		})
	}

	if activity.TID != currentUser.TID {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"errorMessage": "Unauthorized Access",
		})
	}

	globalContext.GetDatabase().DeleteLogByUUID(uuid)

	return c.NoContent(http.StatusNoContent)
}
