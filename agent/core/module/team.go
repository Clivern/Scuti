// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package module

import (
	"github.com/clivern/mandrill/core/migration"
	"github.com/clivern/mandrill/core/model"
)

// CreateTeam creates a new Team
func (db *Database) CreateTeam(team *model.Team) *model.Team {
	db.Connection.Create(team)

	return team
}

// UpdateTeam updates a Team
func (db *Database) UpdateTeam(team model.Team) model.Team {
	db.Connection.Save(team)

	return team
}

// GetTeamByID gets a Team by ID
func (db *Database) GetTeamByID(id int) model.Team {
	team := model.Team{}

	db.Connection.Where("id = ?", id).First(&team)

	return team
}

// GetTeamByUUID gets a Team by UUID
func (db *Database) GetTeamByUUID(uuid string) model.Team {
	team := model.Team{}

	db.Connection.Where("uuid = ?", uuid).First(&team)

	return team
}

// DeleteTeamByID deletes a Team by ID
func (db *Database) DeleteTeamByID(id int) {
	db.Connection.Unscoped().Where("id = ?", id).Delete(&migration.Team{})
}

// DeleteTeamByUUID deletes a Team by UUID
func (db *Database) DeleteTeamByUUID(uuid string) {
	db.Connection.Unscoped().Where("uuid = ?", uuid).Delete(&migration.Team{})
}

// GetTeams gets Teams
func (db *Database) GetTeams() []model.Team {
	users := []model.Team{}

	db.Connection.Select("*").Find(&users)

	return users
}
