// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package module

import (
	"golang.org/x/crypto/bcrypt"

	"github.com/clivern/mandrill/core/migration"
	"github.com/clivern/mandrill/core/model"
)

// CreateUser creates a new User
func (db *Database) CreateUser(user *model.User) *model.User {
	db.Connection.Create(user)

	return user
}

// UpdateUser updates a User
func (db *Database) UpdateUser(user model.User) model.User {
	db.Connection.Save(user)

	return user
}

// GetUserByID gets a User by ID
func (db *Database) GetUserByID(id int) model.User {
	user := model.User{}

	db.Connection.Where("id = ?", id).First(&user)

	return user
}

// GetUserByUUID gets a User by UUID
func (db *Database) GetUserByUUID(uuid string) model.User {
	user := model.User{}

	db.Connection.Where("uuid = ?", uuid).First(&user)

	return user
}

// GetUserByEmail gets a User by Email
func (db *Database) GetUserByEmail(email string) model.User {
	user := model.User{}

	db.Connection.Where("email = ?", email).First(&user)

	return user
}

// DeleteUserByID deletes a User by ID
func (db *Database) DeleteUserByID(id int) {
	db.Connection.Unscoped().Where("id = ?", id).Delete(&migration.User{})
}

// DeleteUserByUUID deletes a User by UUID
func (db *Database) DeleteUserByUUID(uuid string) {
	db.Connection.Unscoped().Where("uuid = ?", uuid).Delete(&migration.User{})
}

// DeleteUserByEmail deletes a User by Email
func (db *Database) DeleteUserByEmail(email string) {
	db.Connection.Unscoped().Where("email = ?", email).Delete(&migration.User{})
}

// GetUsers gets Users
func (db *Database) GetUsers() []model.User {
	users := []model.User{}

	db.Connection.Select("*").Find(&users)

	return users
}

// GeneratePasswordHash generates a hash from a password
func (db *Database) GeneratePasswordHash(password string) (string, error) {
	hash, err := bcrypt.GenerateFromPassword(
		[]byte(password),
		bcrypt.DefaultCost,
	)

	if err != nil {
		return "", err
	}

	return string(hash), nil
}

// ValidatePassword validate if a password match a hash
func (db *Database) ValidatePassword(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))

	if err != nil {
		return false
	}

	return true
}
