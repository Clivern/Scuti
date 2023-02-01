// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package model

import (
	"time"

	"github.com/clivern/mandrill/core/util"
)

// User struct
type User struct {
	ID           int       `json:"id"`
	TID          int       `json:"tid"`
	UUID         string    `json:"uuid"`
	Name         string    `json:"name"`
	Email        string    `json:"email"`
	PasswordHash string    `json:"passwordHash"`
	Status       string    `json:"status"`
	Role         string    `json:"role"`
	Meta         string    `json:"meta"`
	CreatedAt    time.Time `json:"createdAt"`
	UpdatedAt    time.Time `json:"updatedAt"`
}

// Users struct
type Users struct {
	Users []User `json:"users"`
}

// LoadFromJSON update object from json
func (u *User) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(u, data)
}

// ConvertToJSON convert object to json
func (u *User) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(u)
}

// LoadFromJSON update object from json
func (u *Users) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(u, data)
}

// ConvertToJSON convert object to json
func (u *Users) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(u)
}

// IsNil if option is nil
func (u *User) IsNil() bool {
	return u.ID == 0
}
