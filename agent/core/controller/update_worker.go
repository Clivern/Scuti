// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package controller

import (
	"os/exec"

	"github.com/clivern/scuti/agent/core/model"
	"github.com/clivern/scuti/agent/core/module"

	log "github.com/sirupsen/logrus"
)

// UpdateWorker Function
func UpdateWorker(messages <-chan string) {

	agent := module.NewAgent()

	for message := range messages {

		cmd := &model.Command{}
		cmd.LoadFromJSON([]byte(message))

		command := exec.Command(
			"DEBIAN_FRONTEND=noninteractive",
			"apt-get",
			"-q",
			"-y",
			"-o",
			"Dpkg::Options::=--force-confdef",
			"-o",
			"Dpkg::Options::=--force-confold",
			"upgrade",
		)

		_, err := command.Output()

		if err == nil {
			// Get last update date on debian based $ cat /var/log/apt/history.log | grep "End-Date:" | tail -1

			log.Info(`Report back to management server`)

			agent.Report(module.AgentEvent{
				Type:     "host_updated_successfully",
				Record:   "Host updated successfully",
				TaskUUID: cmd.TaskUUID,
			})
		} else {
			log.WithFields(log.Fields{
				"err": err.Error(),
			}).Error(`Local command error`)

			log.Info(`Report back to management server`)

			agent.Report(module.AgentEvent{
				Type:     "host_failed_to_update",
				Record:   "Host failed to update",
				TaskUUID: cmd.TaskUUID,
			})
		}
	}
}
