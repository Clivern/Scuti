// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package controller

import (
	"net/http"

	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
)

// DashboardAction Controller
func DashboardAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to Dashboard Action`)

	currentUser := globalContext.CurrentUser(c.Request().Header.Get("x-api-key"))

	result := make(map[string]interface{})

	if currentUser.Role == "super" {
		result["teams_count"] = 0
		result["hostgroups_count"] = 0
		result["hosts_count"] = 0
		result["users_count"] = 0
		result["deployments_count"] = 0
		result["stream"] = []string{}
	} else {
		result["hostgroups_count"] = 0
		result["hosts_count"] = 0
		result["deployments_count"] = 0
		result["stream"] = []string{}
	}

	return c.JSON(http.StatusOK, result)
}
