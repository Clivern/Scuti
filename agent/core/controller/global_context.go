// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package controller

import (
	"github.com/clivern/mandrill/core/model"
	"github.com/clivern/mandrill/core/module"
)

// GlobalContext type
type GlobalContext struct {
	Database *module.Database
}

// GetDatabase gets a database connection
func (c *GlobalContext) GetDatabase() *module.Database {
	return c.Database
}

// CurrentUser gets a current user
func (c *GlobalContext) CurrentUser(session_value string) model.User {

	session := c.Database.GetSessionByValue(session_value)

	if session.IsNil() {
		return model.User{}
	}

	user := c.Database.GetUserByID(session.UID)

	if user.IsNil() {
		return model.User{}
	}

	return user
}
