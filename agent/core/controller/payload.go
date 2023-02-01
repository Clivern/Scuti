// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package controller

import (
	"io/ioutil"

	"github.com/clivern/mandrill/core/util"
	"github.com/labstack/echo/v4"
	log "github.com/sirupsen/logrus"
)

// GetRequestData gets a request data
func GetRequestData(c echo.Context) (map[string]string, error) {

	var inputs map[string]string

	data, err := ioutil.ReadAll(c.Request().Body)

	if err != nil {
		return inputs, err
	}

	err = util.LoadFromJSON(&inputs, data)

	if err != nil {
		return inputs, err
	}

	fields := log.Fields{}

	for k, v := range inputs {
		if k == "password" {
			v = "**********"
		}

		if k == "admin_password" {
			v = "**********"
		}

		fields[k] = v
	}

	fields["uri"] = c.Request().URL.String()

	log.WithFields(fields).Info(`Incoming request payload`)

	return inputs, nil
}
