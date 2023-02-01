// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package module

import (
	"github.com/clivern/mandrill/core/migration"
	"github.com/clivern/mandrill/core/model"
)

// CreateOption creates a new Option
func (db *Database) CreateOption(option *model.Option) *model.Option {
	db.Connection.Create(option)

	return option
}

// UpdateOption updates an Option
func (db *Database) UpdateOption(option *model.Option) *model.Option {
	db.Connection.Save(&option)

	return option
}

// GetOptionByKey gets an Option by Key
func (db *Database) GetOptionByKey(key string) model.Option {
	option := model.Option{}

	db.Connection.Where("key = ?", key).First(&option)

	return option
}

// DeleteOptionByKey deletes an Option by Key
func (db *Database) DeleteOptionByKey(key string) {
	db.Connection.Unscoped().Where("key = ?", key).Delete(&migration.Option{})
}

// GetOptions gets Options
func (db *Database) GetOptions() []model.Option {
	options := []model.Option{}

	db.Connection.Select("*").Find(&options)

	return options
}
