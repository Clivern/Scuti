// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package module

import (
	"github.com/clivern/mandrill/core/migration"
	"github.com/clivern/mandrill/core/model"
)

// CreateLog creates a new Log
func (db *Database) CreateLog(log *model.Log) *model.Log {
	db.Connection.Create(log)

	return log
}

// UpdateLog updates a Log
func (db *Database) UpdateLog(log *model.Log) *model.Log {
	db.Connection.Save(&log)

	return log
}

// GetLogByID gets a Log by ID
func (db *Database) GetLogByID(id int) model.Log {
	log := model.Log{}

	db.Connection.Where("id = ?", id).First(&log)

	return log
}

// GetLogByUUID gets a Log by UUID
func (db *Database) GetLogByUUID(uuid string) model.Log {
	log := model.Log{}

	db.Connection.Where("uuid = ?", uuid).First(&log)

	return log
}

// DeleteLogByID deletes an entity by ID
func (db *Database) DeleteLogByID(id int) {
	db.Connection.Unscoped().Where("id = ?", id).Delete(&migration.Log{})
}

// DeleteLogByUUID deletes an entity by UUID
func (db *Database) DeleteLogByUUID(uuid string) {
	db.Connection.Unscoped().Where("uuid = ?", uuid).Delete(&migration.Log{})
}

// DeleteLogsByHost deletes Logs By Host ID
func (db *Database) DeleteLogsByHost(id int) {
	db.Connection.Unscoped().Where("h_id = ?", id).Delete(&migration.Log{})
}

// DeleteLogsByHostGroup deletes Logs by Host Group ID
func (db *Database) DeleteLogsByHostGroup(id int) {
	db.Connection.Unscoped().Where("hg_id = ?", id).Delete(&migration.Log{})
}

// DeleteLogsByDeployment deletes Logs by Deployment ID
func (db *Database) DeleteLogsByDeployment(id int) {
	db.Connection.Unscoped().Where("d_id = ?", id).Delete(&migration.Log{})
}

// DeleteLogsByTeam deletes Logs by Team ID
func (db *Database) DeleteLogsByTeam(id int) {
	db.Connection.Unscoped().Where("t_id = ?", id).Delete(&migration.Log{})
}

// GetLogsByTeam gets Logs by Team ID
func (db *Database) GetLogsByTeam(id int) []model.Log {
	logs := []model.Log{}

	db.Connection.Select("*").Where("t_id = ?", id).Find(&logs)

	return logs
}

// GetLogsByHost gets Logs by Host ID
func (db *Database) GetLogsByHost(id int, team int) []model.Log {
	logs := []model.Log{}

	db.Connection.Select("*").Where("h_id = ? AND t_id = ?", id, team).Find(&logs)

	return logs
}

// GetLogsByHostGroup gets Logs by Host Group ID
func (db *Database) GetLogsByHostGroup(id int, team int) []model.Log {
	logs := []model.Log{}

	db.Connection.Select("*").Where("hg_id = ? AND t_id = ?", id, team).Find(&logs)

	return logs
}

// GetLogsByDeployment gets Logs by Deployment ID
func (db *Database) GetLogsByDeployment(id int, team int) []model.Log {
	logs := []model.Log{}

	db.Connection.Select("*").Where("d_id = ? AND t_id = ?", id, team).Find(&logs)

	return logs
}
