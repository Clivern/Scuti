// Copyright 2022 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package model

import (
	"time"

	"github.com/clivern/mandrill/core/util"
)

// HostGroup struct
type HostGroup struct {
	ID        int       `json:"id"`
	TID       int       `json:"tid"`
	UUID      string    `json:"uuid"`
	Name      string    `json:"name"`
	ApiKey    string    `json:"apiKey"`
	Labels    string    `json:"labels"`
	Meta      string    `json:"meta"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
}

// HostGroups struct
type HostGroups struct {
	HostGroups []HostGroup `json:"hostGroups"`
}

// LoadFromJSON update object from json
func (h *HostGroup) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(h, data)
}

// ConvertToJSON convert object to json
func (h *HostGroup) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(h)
}

// LoadFromJSON update object from json
func (h *HostGroups) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(h, data)
}

// ConvertToJSON convert object to json
func (h *HostGroups) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(h)
}

// IsNil if option is nil
func (h *HostGroup) IsNil() bool {
	return h.ID == 0
}
