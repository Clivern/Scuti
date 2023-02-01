// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package module

import (
	"fmt"
	"testing"

	"github.com/clivern/mandrill/pkg"

	"github.com/franela/goblin"
)

// TestUnitDatabase
func TestUnitDatabase(t *testing.T) {
	g := goblin.Goblin(t)

	pkg.LoadConfigs(fmt.Sprintf("%s/config.dist.yml", pkg.GetBaseDir("cache")))

	database := &Database{}

	// Reset DB
	database.AutoConnect()
	database.Rollback()

	defer database.Close()

	g.Describe("#Migrate", func() {
		g.It("It should satisfy test cases", func() {
			g.Assert(database.AutoConnect()).Equal(nil)
			g.Assert(database.Ping()).Equal(nil)

			g.Assert(database.Migrate()).Equal(true)
			g.Assert(database.HasTable("teams")).Equal(true)
			g.Assert(database.HasTable("users")).Equal(true)
			g.Assert(database.HasTable("host_groups")).Equal(true)
			g.Assert(database.HasTable("hosts")).Equal(true)
			g.Assert(database.HasTable("deployments")).Equal(true)
			g.Assert(database.HasTable("tasks")).Equal(true)
			g.Assert(database.HasTable("logs")).Equal(true)
			g.Assert(database.HasTable("user")).Equal(false)
		})
	})
}
