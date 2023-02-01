// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package model

import (
	"time"

	"github.com/clivern/mandrill/core/util"
)

// Session struct
type Session struct {
	ID        int       `json:"id"`
	UID       int       `json:"uid"`
	HID       int       `json:"hid"`
	UUID      string    `json:"uuid"`
	Value     string    `json:"value"`
	Meta      string    `json:"meta"`
	CanExpire string    `json:"canExpire"`
	ExpiredAt time.Time `json:"expiredAt"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
}

// Sessions struct
type Sessions struct {
	Sessions []Session `json:"sessions"`
}

// LoadFromJSON update object from json
func (s *Session) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(s, data)
}

// ConvertToJSON convert object to json
func (s *Session) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(s)
}

// LoadFromJSON update object from json
func (s *Sessions) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(s, data)
}

// ConvertToJSON convert object to json
func (s *Sessions) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(s)
}

// IsNil if option is nil
func (s *Session) IsNil() bool {
	return s.ID == 0
}
