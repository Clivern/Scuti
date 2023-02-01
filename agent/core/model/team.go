// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package model

import (
	"time"

	"github.com/clivern/mandrill/core/util"
)

// Team struct
type Team struct {
	ID        int       `json:"id"`
	UUID      string    `json:"uuid"`
	Name      string    `json:"name"`
	Meta      string    `json:"meta"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
}

// Teams struct
type Teams struct {
	Teams []Team `json:"teams"`
}

// LoadFromJSON update object from json
func (t *Team) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(t, data)
}

// ConvertToJSON convert object to json
func (t *Team) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(t)
}

// LoadFromJSON update object from json
func (t *Teams) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(t, data)
}

// ConvertToJSON convert object to json
func (t *Teams) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(t)
}

// IsNil if option is nil
func (t *Team) IsNil() bool {
	return t.ID == 0
}
