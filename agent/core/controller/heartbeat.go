// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package controller

import (
	"net/http"

	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
)

// HeartbeatAction Controller
func HeartbeatAction(c echo.Context, _ *GlobalContext) error {

	log.Info(`Incoming Request to Heartbeat Action`)

	return c.JSON(http.StatusOK, map[string]interface{}{
		"status": "ok",
	})
}
