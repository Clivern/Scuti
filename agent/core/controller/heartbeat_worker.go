// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package controller

import (
	"os"
	"strings"
	"time"

	"github.com/clivern/scuti/agent/core/module"

	log "github.com/sirupsen/logrus"
	"github.com/spf13/viper"
)

// HeartbeatWorker Function
func HeartbeatWorker() {
	time.Sleep(6 * time.Second)

	agent := module.NewAgent()

	log.WithFields(log.Fields{
		"name": viper.GetString("agent.name"),
	}).Info(`Heartbeat Worker is started ...`)

	hostname, err := os.Hostname()

	if err != nil {
		hostname = viper.GetString("agent.name")

		log.WithFields(log.Fields{
			"error": err.Error(),
		}).Error(`Failure to get hostname`)
	}

	err = agent.Join(module.JoinRequest{
		Name:         viper.GetString("agent.name"),
		Hostname:     strings.ToLower(hostname),
		AgentAddress: viper.GetString("agent.address"),
		Labels:       viper.GetString("agent.labels"),
		AgentSecret:  viper.GetString("agent.management.host_secret"),
	})

	if err != nil {
		log.WithFields(log.Fields{
			"error": err.Error(),
		}).Error(`Error raised during join`)
	}

	for {
		time.Sleep(60 * time.Second)

		log.WithFields(log.Fields{
			"name": viper.GetString("agent.name"),
		}).Info(`Trigger agent heartbeat`)

		err = agent.Heartbeat(module.HeartbeatRequest{Status: "up"})

		if err != nil {
			log.WithFields(log.Fields{
				"error": err.Error(),
			}).Error(`Error raised during hearbeat`)
		}
	}
}
