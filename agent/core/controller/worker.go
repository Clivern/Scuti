// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package controller

import (
	"time"

	"github.com/clivern/scuti/agent/core/module"

	log "github.com/sirupsen/logrus"
	"github.com/spf13/viper"
)

// Worker Function
func Worker() {
	time.Sleep(6 * time.Second)

	agent := module.NewAgent()

	log.WithFields(log.Fields{
		"name": viper.GetString("agent.name"),
	}).Info(`Worker is started ...`)

	hostname, err := os.Hostname()

	log.WithFields(log.Fields{
		"error": err.Error(),
	}).Error(`Failure to get hostname`)

	err = agent.Join(module.JoinRequest{
		Name:         viper.GetString("agent.name"),
		Hostname:     hostname,
		AgentAddress: viper.GetString("agent.management.address"),
		Labels:       "dc=ams1",
		AgentSecret:  viper.GetString("agent.management.host_secret"),
	})

	log.WithFields(log.Fields{
		"error": err.Error(),
	}).Error(`Error raised during join`)

	for {
		time.Sleep(60 * time.Second)

		log.WithFields(log.Fields{
			"name": viper.GetString("agent.name"),
		}).Info(`Trigger agent heartbeat`)

		err = agent.Heartbeat(module.HeartbeatRequest{Status: "up"})

		log.WithFields(log.Fields{
			"error": err.Error(),
		}).Error(`Error raised during hearbeat`)
	}
}
