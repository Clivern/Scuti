// Copyright 2022 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package model

import (
	"time"

	"github.com/clivern/mandrill/core/util"
)

// Deployment struct
type Deployment struct {
	ID                    int       `json:"id"`
	TID                   int       `json:"tid"`
	UUID                  string    `json:"uuid"`
	Name                  string    `json:"name"`
	HostsList             string    `json:"hostsList"`
	HostGroupsList        string    `json:"hostGroupsList"`
	HostFilters           string    `json:"hostFilters"`
	HostGroupsFilters     string    `json:"hostGroupsFilters"`
	UpgradeType           string    `json:"upgradeType"`
	PackagesToUpgrade     string    `json:"packageToUpgrade"`
	PackagesToExclude     string    `json:"packagesToExclude"`
	PrePatchScript        string    `json:"prePatchScript"`
	PostPatchScript       string    `json:"postPatchScript"`
	PostPatchRebootOption string    `json:"postPatchRebootOption"`
	RolloutOptions        string    `json:"rolloutOptions"`
	ScheduleType          string    `json:"scheduleType"`
	ScheduleTime          time.Time `json:"scheduleTime"`
	Meta                  string    `json:"meta"`
	Status                string    `json:"status"`
	RunAt                 time.Time `json:"runAt"`
	CreatedAt             time.Time `json:"createdAt"`
	UpdatedAt             time.Time `json:"updatedAt"`
}

// Deployments struct
type Deployments struct {
	Deployments []Deployment `json:"deployments"`
}

// LoadFromJSON update object from json
func (d *Deployment) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(d, data)
}

// ConvertToJSON convert object to json
func (d *Deployment) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(d)
}

// LoadFromJSON update object from json
func (d *Deployments) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(d, data)
}

// ConvertToJSON convert object to json
func (d *Deployments) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(d)
}

// IsNil if option is nil
func (d *Deployment) IsNil() bool {
	return d.ID == 0
}
