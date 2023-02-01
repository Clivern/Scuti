// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package module

import (
	"time"

	"github.com/clivern/mandrill/core/migration"
	"github.com/clivern/mandrill/core/model"
)

// CreateSession creates a new Session
func (db *Database) CreateSession(session *model.Session) *model.Session {
	db.Connection.Create(session)

	return session
}

// UpdateSession updates a Session
func (db *Database) UpdateSession(session *model.Session) *model.Session {
	db.Connection.Save(&session)

	return session
}

// GetSessionByID gets a Session by ID
func (db *Database) GetSessionByID(id int) model.Session {
	session := model.Session{}

	db.Connection.Where("id = ?", id).First(&session)

	return session
}

// GetSessionByUUID gets a Session by UUID
func (db *Database) GetSessionByUUID(uuid string) model.Session {
	session := model.Session{}

	db.Connection.Where("uuid = ?", uuid).First(&session)

	return session
}

// GetSessionByValue gets a Session by Value
func (db *Database) GetSessionByValue(value string) model.Session {
	session := model.Session{}

	db.Connection.Where("value = ?", value).First(&session)

	return session
}

// DeleteSessionByID deletes a Session by ID
func (db *Database) DeleteSessionByID(id int) {
	db.Connection.Unscoped().Where("id = ?", id).Delete(&migration.Session{})
}

// DeleteSessionByUUID deletes a Session by UUID
func (db *Database) DeleteSessionByUUID(uuid string) {
	db.Connection.Unscoped().Where("uuid = ?", uuid).Delete(&migration.Session{})
}

// GetSessions gets Sessions
func (db *Database) GetSessions() []model.Session {
	sessions := []model.Session{}

	db.Connection.Select("*").Find(&sessions)

	return sessions
}

// GetSessionsByUser gets Sessions by User ID
func (db *Database) GetSessionsByUser(id int) []model.Session {
	sessions := []model.Session{}

	db.Connection.Select("*").Where("uid = ?", id).Find(&sessions)

	return sessions
}

// RemoveExpiredSessions removes expired sessions
func (db *Database) RemoveExpiredSessions() {
	db.Connection.Unscoped().Where("can_expire = ?", "yes").Where("expired_at < ?", time.Now()).Delete(&migration.Session{})
}

// RemoveUserSessions removes user sessions
func (db *Database) RemoveUserSessions(id int) {
	db.Connection.Unscoped().Where("uid = ?", id).Delete(&migration.Session{})
}
