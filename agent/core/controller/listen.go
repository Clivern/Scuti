// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package controller

import (
	"io/ioutil"
	"net/http"

	"github.com/clivern/scuti/agent/core/model"
	"github.com/clivern/scuti/agent/core/module"

	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
)

// ListenAction Controller
func ListenAction(c echo.Context, messages chan<- string) error {

	log.Info(`Incoming Request to Listen Action`)

	data, _ := ioutil.ReadAll(c.Request().Body)

	cmd := &model.Command{}

	err := cmd.LoadFromJSON(data)

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "Invalid request",
		})
	}

	webhookToken := c.Request().Header.Get("X-Webhook-Token")

	agent := module.NewAgent()

	if !agent.ValidateManagementCommandRequest(*cmd, webhookToken) {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"errorMessage": "Invalid request",
		})
	}

	messages <- string(data)

	return c.JSON(http.StatusAccepted, map[string]interface{}{
		"status": "ok",
	})
}
