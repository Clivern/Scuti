// Copyright 2021 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package module

import (
	"github.com/clivern/mandrill/core/migration"
	"github.com/clivern/mandrill/core/model"
)

// CreateHost creates a new entity
func (db *Database) CreateHost(host *model.Host) *model.Host {
	db.Connection.Create(host)

	return host
}

// UpdateHost updates an entity
func (db *Database) UpdateHost(host *model.Host) *model.Host {
	db.Connection.Save(&host)

	return host
}

// GetHostByID gets an entity by ID
func (db *Database) GetHostByID(id int) model.Host {
	host := model.Host{}

	db.Connection.Where("id = ?", id).First(&host)

	return host
}

// GetHostByUUID gets an entity by UUID
func (db *Database) GetHostByUUID(uuid string) model.Host {
	host := model.Host{}

	db.Connection.Where("uuid = ?", uuid).First(&host)

	return host
}

// DeleteHostByID deletes an entity by ID
func (db *Database) DeleteHostByID(id int) {
	db.Connection.Unscoped().Where("id = ?", id).Delete(&migration.Host{})
}

// DeleteHostByUUID deletes an entity by UUID
func (db *Database) DeleteHostByUUID(uuid string) {
	db.Connection.Unscoped().Where("uuid = ?", uuid).Delete(&migration.Host{})
}

// GetHostsByGroup gets hosts by host group ID
func (db *Database) GetHostsByGroup(id int) []model.Host {
	hosts := []model.Host{}

	db.Connection.Select("*").Where("hgid = ?", id).Find(&hosts)

	return hosts
}

// GetHostsByUser gets hosts by User ID
func (db *Database) GetHostsByUser(id int) []model.Host {
	hosts := []model.Host{}

	db.Connection.Select("*").Where("uid = ?", id).Find(&hosts)

	return hosts
}
