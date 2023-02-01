// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package module

import (
	"github.com/clivern/mandrill/core/migration"
	"github.com/clivern/mandrill/core/model"
)

// CreateTask creates a new Task
func (db *Database) CreateTask(task *model.Task) *model.Task {
	db.Connection.Create(task)

	return task
}

// UpdateTask updates a Task
func (db *Database) UpdateTask(task *model.Task) *model.Task {
	db.Connection.Save(&task)

	return task
}

// GetTaskByID gets a Task by ID
func (db *Database) GetTaskByID(id int) model.Task {
	task := model.Task{}

	db.Connection.Where("id = ?", id).First(&task)

	return task
}

// GetTaskByUUID gets a Task by UUID
func (db *Database) GetTaskByUUID(uuid string) model.Task {
	task := model.Task{}

	db.Connection.Where("uuid = ?", uuid).First(&task)

	return task
}

// DeleteTaskByID deletes a Task by ID
func (db *Database) DeleteTaskByID(id int) {
	db.Connection.Unscoped().Where("id = ?", id).Delete(&migration.Task{})
}

// DeleteTaskByUUID deletes a Task by UUID
func (db *Database) DeleteTaskByUUID(uuid string) {
	db.Connection.Unscoped().Where("uuid = ?", uuid).Delete(&migration.Task{})
}

// GetTasksByDeployment gets Tasks by Deployment
func (db *Database) GetTasksByDeployment(id int) []model.Task {
	tasks := []model.Task{}

	db.Connection.Select("*").Where("d_id = ?", id).Find(&tasks)

	return tasks
}
