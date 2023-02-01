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

// TestUnitUser
func TestUnitUser(t *testing.T) {
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

			hash, err := database.GeneratePasswordHash("$123456827Aa$")

			g.Assert(err).Equal(nil)
			g.Assert(hash != "").Equal(true)

			g.Assert(database.ValidatePassword("$123456827Aa$", hash)).Equal(true)
			g.Assert(database.ValidatePassword("$123456827Aa", hash)).Equal(false)
		})
	})
}
