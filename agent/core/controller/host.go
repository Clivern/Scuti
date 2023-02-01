// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package controller

import (
	"fmt"
	"net/http"

	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
)

// GetHostsAction Controller
func GetHostsAction(c echo.Context, _ *GlobalContext) error {

	log.Info(`Incoming Request to GetHosts Action`)

	return c.JSON(http.StatusOK, map[string]interface{}{
		"status": "ok",
	})
}

// GetHostAction Controller
func GetHostAction(c echo.Context, _ *GlobalContext) error {

	log.Info(`Incoming Request to GetHost Action`)

	// uuid := c.Param("uuid")

	return c.JSON(http.StatusOK, map[string]interface{}{
		"status": "ok",
	})
}

// CreateHostAction Controller
func CreateHostAction(c echo.Context, _ *GlobalContext) error {

	log.Info(`Incoming Request to CreateHost Action`)

	// uuid := c.Param("uuid")

	return c.JSON(http.StatusOK, map[string]interface{}{
		"status": "ok",
	})
}

// UpdateHostAction Controller
func UpdateHostAction(c echo.Context, _ *GlobalContext) error {

	log.Info(`Incoming Request to UpdateHost Action`)

	// uuid := c.Param("uuid")

	return c.JSON(http.StatusOK, map[string]interface{}{
		"status": "ok",
	})
}

// DeleteHostAction Controller
func DeleteHostAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to DeleteHost Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	uuid := c.Param("uuid")

	host := globalContext.GetDatabase().GetHostByUUID(uuid)

	if host.IsNil() {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"errorMessage": fmt.Sprintf("Task with UUID %s not found", uuid),
		})
	}

	if host.TID != currentUser.TID {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"errorMessage": "Unauthorized Access",
		})
	}

	globalContext.GetDatabase().DeleteHostByUUID(uuid)

	return c.NoContent(http.StatusNoContent)
}
