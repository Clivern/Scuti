// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package model

import (
	"time"

	"github.com/clivern/mandrill/core/util"
)

// Task struct
type Task struct {
	ID        int       `json:"id"`
	DID       int       `json:"did"`
	UUID      string    `json:"uuid"`
	Payload   string    `json:"payload"`
	Result    string    `json:"result"`
	Status    string    `json:"status"`
	Meta      string    `json:"meta"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
}

// Tasks struct
type Tasks struct {
	Tasks []Task `json:"tasks"`
}

// LoadFromJSON update object from json
func (t *Task) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(t, data)
}

// ConvertToJSON convert object to json
func (t *Task) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(t)
}

// LoadFromJSON update object from json
func (t *Tasks) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(t, data)
}

// ConvertToJSON convert object to json
func (t *Tasks) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(t)
}

// IsNil if option is nil
func (t *Task) IsNil() bool {
	return t.ID == 0
}
