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

// GetDeploymentsAction Controller
func GetDeploymentsAction(c echo.Context, _ *GlobalContext) error {

	log.Info(`Incoming Request to GetDeployments Action`)

	return c.JSON(http.StatusOK, map[string]interface{}{
		"status": "ok",
	})
}

// GetDeploymentAction Controller
func GetDeploymentAction(c echo.Context, _ *GlobalContext) error {

	log.Info(`Incoming Request to GetDeployment Action`)

	// uuid := c.Param("uuid")

	return c.JSON(http.StatusOK, map[string]interface{}{
		"status": "ok",
	})
}

// CreateDeploymentAction Controller
func CreateDeploymentAction(c echo.Context, _ *GlobalContext) error {

	log.Info(`Incoming Request to CreateDeployment Action`)

	// uuid := c.Param("uuid")

	return c.JSON(http.StatusOK, map[string]interface{}{
		"status": "ok",
	})
}

// UpdateDeploymentAction Controller
func UpdateDeploymentAction(c echo.Context, _ *GlobalContext) error {

	log.Info(`Incoming Request to UpdateDeployment Action`)

	// uuid := c.Param("uuid")

	return c.JSON(http.StatusOK, map[string]interface{}{
		"status": "ok",
	})
}

// DeleteDeploymentAction Controller
func DeleteDeploymentAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to DeleteDeployment Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	uuid := c.Param("uuid")

	deployment := globalContext.GetDatabase().GetDeploymentByUUID(uuid)

	if deployment.IsNil() {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"errorMessage": fmt.Sprintf("Deployment with UUID %s not found", uuid),
		})
	}

	if deployment.TID != currentUser.TID {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"errorMessage": "Unauthorized Access",
		})
	}

	globalContext.GetDatabase().DeleteDeploymentByUUID(uuid)

	return c.NoContent(http.StatusNoContent)
}
