// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package migration

import (
	"time"

	"github.com/clivern/mandrill/core/util"

	"github.com/jinzhu/gorm"
)

// Option struct
type Option struct {
	gorm.Model

	UUID  string `json:"uuid"`
	Key   string `json:"key"`
	Value string `json:"value"`
}

// LoadFromJSON update object from json
func (o *Option) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(o, data)
}

// ConvertToJSON convert object to json
func (o *Option) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(o)
}

// Team struct
type Team struct {
	gorm.Model

	UUID string `json:"uuid"`
	Name string `json:"name"`
	Meta string `json:"meta"`
}

// LoadFromJSON update object from json
func (t *Team) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(t, data)
}

// ConvertToJSON convert object to json
func (t *Team) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(t)
}

// User struct
type User struct {
	gorm.Model

	TID          int    `json:"tid"`
	UUID         string `json:"uuid"`
	Name         string `json:"name"`
	Email        string `json:"email"`
	PasswordHash string `json:"passwordHash"`
	Status       string `json:"status"`
	Role         string `json:"role"`
	Meta         string `json:"meta"`
}

// LoadFromJSON update object from json
func (u *User) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(u, data)
}

// ConvertToJSON convert object to json
func (u *User) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(u)
}

// HostGroup struct
type HostGroup struct {
	gorm.Model

	// Team ID
	TID    int    `json:"tid"`
	UUID   string `json:"uuid"`
	Name   string `json:"name"`
	ApiKey string `json:"apiKey"`
	Labels string `json:"labels"`
	Meta   string `json:"meta"`
}

// LoadFromJSON update object from json
func (g *HostGroup) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(g, data)
}

// ConvertToJSON convert object to json
func (g *HostGroup) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(g)
}

// Host struct
type Host struct {
	gorm.Model

	// Team ID
	TID int `json:"tid"`
	// Host Group ID
	HGID       int    `json:"hgid"`
	UUID       string `json:"uuid"`
	Name       string `json:"name"`
	HostName   string `json:"hostName"`
	PrivateIPs string `json:"privateIPs"`
	PublicIPs  string `json:"publicIPs"`
	Labels     string `json:"labels"`
	Status     string `json:"status"`
	Meta       string `json:"meta"`
	ReportedAt time.Time
}

// LoadFromJSON update object from json
func (h *Host) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(h, data)
}

// ConvertToJSON convert object to json
func (h *Host) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(h)
}

// Deployment struct
type Deployment struct {
	gorm.Model

	// Team ID
	TID  int    `json:"tid"`
	UUID string `json:"uuid"`
	Name string `json:"name"`
	// Hosts List to Upgrade
	HostsList string `json:"hostsList"`
	// Host Groups List to Upgrade
	HostGroupsList string `json:"hostGroupsLists"`
	// Host Filter
	HostFilters string `json:"hostFilters"`
	// Host Group Filter
	HostGroupsFilters string `json:"hostGroupsFilters"`
	// dist-upgrade or upgrade
	UpgradeType string `json:"upgradeType"`
	// List of packages to upgrade
	PackagesToUpgrade string `json:"packagesToUpgrade"`
	// List of packages to exclude from upgrade
	PackagesToExclude string `json:"packagesToExclude"`
	// Pre Patch Script
	PrePatchScript string `json:"prePatchScript"`
	// Post Patch Script
	PostPatchScript string `json:"postPatchScript"`
	// Default (if reboot is needed) or Always or Never
	PostPatchRebootOption string `json:"postPatchRebootOption"`
	// PercentOfVms (25%) or NumberOfVms (4)
	RolloutOptions string `json:"rolloutOptions"`
	// Recurring or One Time
	ScheduleType string `json:"scheduleType"`
	// Time in the future
	ScheduleTime time.Time `json:"scheduleTime"`
	// Last Status
	Status string `json:"status"`
	Meta   string `json:"meta"`
	// Last Run At
	RunAt time.Time `json:"runAt"`
}

// LoadFromJSON update object from json
func (d *Deployment) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(d, data)
}

// ConvertToJSON convert object to json
func (d *Deployment) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(d)
}

// Task struct
type Task struct {
	gorm.Model

	// Deployment ID
	DID     int    `json:"did"`
	UUID    string `json:"uuid"`
	Payload string `json:"payload"`
	Result  string `json:"result"`
	Status  string `json:"status"`
	Meta    string `json:"meta"`
}

// LoadFromJSON update object from json
func (t *Task) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(t, data)
}

// ConvertToJSON convert object to json
func (t *Task) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(t)
}

// Log struct
type Log struct {
	gorm.Model

	// Team ID
	TID int `json:"tid"`
	// Host ID
	HID int `json:"hid"`
	// Host Group ID
	HGID int `json:"hgid"`
	// Deployment ID
	DID   int    `json:"did"`
	UUID  string `json:"uuid"`
	Value string `json:"value"`
	Meta  string `json:"meta"`
}

// LoadFromJSON update object from json
func (l *Log) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(l, data)
}

// ConvertToJSON convert object to json
func (l *Log) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(l)
}

// Session struct
type Session struct {
	gorm.Model

	// User ID
	UID       int    `json:"uid"`
	HID       int    `json:"hid"`
	UUID      string `json:"uuid"`
	Value     string `json:"value"`
	Meta      string `json:"meta"`
	CanExpire string `json:"canExpire"`
	ExpiredAt time.Time
}

// LoadFromJSON update object from json
func (s *Session) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(s, data)
}

// ConvertToJSON convert object to json
func (s *Session) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(s)
}
