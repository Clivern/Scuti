// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package controller

import (
	log "github.com/sirupsen/logrus"
	"github.com/spf13/viper"
)

// Worker Function
func Worker() {

	log.WithFields(log.Fields{
		"name": viper.GetString("worker.name"),
	}).Info(`Worker is started ...`)

	for {

	}
}
