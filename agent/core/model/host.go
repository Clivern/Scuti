// Copyright 2022 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package model

import (
	"time"

	"github.com/clivern/mandrill/core/util"
)

// Host struct
type Host struct {
	ID         int       `json:"id"`
	TID        int       `json:"tid"`
	HGID       int       `json:"hgid"`
	UUID       string    `json:"uuid"`
	Name       string    `json:"name"`
	HostName   string    `json:"hostName"`
	PrivateIPs string    `json:"privateIPs"`
	PublicIPs  string    `json:"publicIPs"`
	Labels     string    `json:"labels"`
	Status     string    `json:"status"`
	Meta       string    `json:"meta"`
	ReportedAt time.Time `json:"reportedAt"`
	CreatedAt  time.Time `json:"createdAt"`
	UpdatedAt  time.Time `json:"updatedAt"`
}

// Hosts struct
type Hosts struct {
	Hosts []Host `json:"hosts"`
}

// LoadFromJSON update object from json
func (h *Host) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(h, data)
}

// ConvertToJSON convert object to json
func (h *Host) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(h)
}

// LoadFromJSON update object from json
func (h *Hosts) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(h, data)
}

// ConvertToJSON convert object to json
func (h *Hosts) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(h)
}

// IsNil if option is nil
func (h *Host) IsNil() bool {
	return h.ID == 0
}
