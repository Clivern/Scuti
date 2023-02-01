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

// GetTaskAction Controller
func GetTaskAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to GetTask Action`)

	uuid := c.Param("uuid")

	task := globalContext.GetDatabase().GetTaskByUUID(uuid)

	if task.IsNil() {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"errorMessage": fmt.Sprintf("Task with UUID %s not found", uuid),
		})
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"id":        task.ID,
		"uuid":      task.UUID,
		"did":       task.DID,
		"payload":   task.Payload,
		"result":    task.Result,
		"status":    task.Status,
		"meta":      task.Meta,
		"createdAt": task.CreatedAt,
		"updatedAt": task.UpdatedAt,
	})
}

// DeleteTaskAction Controller
func DeleteTaskAction(c echo.Context, globalContext *GlobalContext) error {

	log.Info(`Incoming Request to DeleteTask Action`)

	uuid := c.Param("uuid")

	task := globalContext.GetDatabase().GetTaskByUUID(uuid)

	if task.IsNil() {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"errorMessage": fmt.Sprintf("Task with UUID %s not found", uuid),
		})
	}

	globalContext.GetDatabase().DeleteTaskByUUID(uuid)

	return c.NoContent(http.StatusNoContent)
}
