// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package model

import (
	"time"

	"github.com/clivern/mandrill/core/util"
)

// Log struct
type Log struct {
	ID        int       `json:"id"`
	TID       int       `json:"tid"`
	HID       int       `json:"hid"`
	HGID      int       `json:"hgid"`
	DID       int       `json:"did"`
	UUID      string    `json:"uuid"`
	Value     string    `json:"value"`
	Meta      string    `json:"meta"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
}

// Logs struct
type Logs struct {
	Logs []Log `json:"logs"`
}

// LoadFromJSON update object from json
func (l *Log) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(l, data)
}

// ConvertToJSON convert object to json
func (l *Log) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(l)
}

// LoadFromJSON update object from json
func (l *Logs) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(l, data)
}

// ConvertToJSON convert object to json
func (l *Logs) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(l)
}

// IsNil if option is nil
func (l *Log) IsNil() bool {
	return l.ID == 0
}
