// Copyright 2021 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package module

import (
	"github.com/clivern/mandrill/core/migration"
	"github.com/clivern/mandrill/core/model"
)

// CreateHostGroup creates a Host Group
func (db *Database) CreateHostGroup(group *model.HostGroup) *model.HostGroup {
	db.Connection.Create(group)

	return group
}

// UpdateHostGroup updates a Host Group
func (db *Database) UpdateHostGroup(group *model.HostGroup) *model.HostGroup {
	db.Connection.Save(&group)

	return group
}

// GetHostGroupByID gets a Host Group by ID
func (db *Database) GetHostGroupByID(id int) model.HostGroup {
	group := model.HostGroup{}

	db.Connection.Where("id = ?", id).First(&group)

	return group
}

// GetHostGroupByUUID gets a Host Group by UUID
func (db *Database) GetHostGroupByUUID(uuid string) model.HostGroup {
	group := model.HostGroup{}

	db.Connection.Where("uuid = ?", uuid).First(&group)

	return group
}

// DeleteHostGroupByID deletes a Host Group by ID
func (db *Database) DeleteHostGroupByID(id int) {
	db.Connection.Unscoped().Where("id = ?", id).Delete(&migration.HostGroup{})
}

// DeleteHostGroupByUUID deletes a Host Group by UUID
func (db *Database) DeleteHostGroupByUUID(uuid string) {
	db.Connection.Unscoped().Where("uuid = ?", uuid).Delete(&migration.HostGroup{})
}

// GetHostGroupsByUser gets Host Groups by User ID
func (db *Database) GetHostGroupsByTeam(id int) []model.HostGroup {
	groups := []model.HostGroup{}

	db.Connection.Select("*").Where("tid", id).Find(&groups)

	return groups
}
