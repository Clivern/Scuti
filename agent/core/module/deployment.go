// Copyright 2021 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package module

import (
	"github.com/clivern/mandrill/core/migration"
	"github.com/clivern/mandrill/core/model"
)

// CreateDeployment creates a Deployment
func (db *Database) CreateDeployment(deployment *model.Deployment) *model.Deployment {
	db.Connection.Create(deployment)

	return deployment
}

// UpdateDeployment updates a Deployment
func (db *Database) UpdateDeployment(deployment *model.Deployment) *model.Deployment {
	db.Connection.Save(&deployment)

	return deployment
}

// GetDeploymentByID gets a Deployment by ID
func (db *Database) GetDeploymentByID(id int) model.Deployment {
	deployment := model.Deployment{}

	db.Connection.Where("id = ?", id).First(&deployment)

	return deployment
}

// GetDeploymentByUUID gets a Deployment by UUID
func (db *Database) GetDeploymentByUUID(uuid string) model.Deployment {
	deployment := model.Deployment{}

	db.Connection.Where("uuid = ?", uuid).First(&deployment)

	return deployment
}

// DeleteDeploymentByID deletes a Deployment by ID
func (db *Database) DeleteDeploymentByID(id int) {
	db.Connection.Unscoped().Where("id = ?", id).Delete(&migration.Deployment{})
}

// DeleteDeploymentByUUID deletes a Deployment by UUID
func (db *Database) DeleteDeploymentByUUID(uuid string) {
	db.Connection.Unscoped().Where("uuid = ?", uuid).Delete(&migration.Deployment{})
}

// GetDeployments gets Deployments
func (db *Database) GetDeployments() []model.Deployment {
	deployments := []model.Deployment{}

	db.Connection.Select("*").Find(&deployments)

	return deployments
}

// GetDeploymentsByUser gets Deployments By User
func (db *Database) GetDeploymentsByUser(id int) []model.Deployment {
	deployments := []model.Deployment{}

	db.Connection.Select("*").Where("uid = ?", id).Find(&deployments)

	return deployments
}
