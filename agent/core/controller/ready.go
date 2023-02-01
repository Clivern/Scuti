// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package controller

import (
	"net/http"

	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
)

// ReadyAction Controller
func ReadyAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to Ready Action`)

	option := globalContext.GetDatabase().GetOptionByKey("app_name")

	if option.IsNil() {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"status": "not ok",
		})
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"status": "ok",
	})
}
