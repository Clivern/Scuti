// Copyright 2022 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package service

import (
	"testing"

	"github.com/franela/goblin"
)

// TestUnitEncrypt
func TestUnitEncrypt(t *testing.T) {
	g := goblin.Goblin(t)

	g.Describe("#Base16Encrypt", func() {
		g.It("It should satisfy test cases", func() {
			msg := Base16Encrypt("the shared secret key here", "the message to hash here")
			result := "4643978965ffcec6e6d73b36a39ae43ceb15f7ef8131b8307862ebc560e7f988"
			g.Assert(msg).Equal(result)
		})
	})

	g.Describe("#Base64Encrypt", func() {
		g.It("It should satisfy test cases", func() {
			msg := Base64Encrypt("the shared secret key here", "the message to hash here")
			result := "RkOXiWX/zsbm1zs2o5rkPOsV9++BMbgweGLrxWDn+Yg="
			g.Assert(msg).Equal(result)
		})
	})
}
