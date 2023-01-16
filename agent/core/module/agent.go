// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package module

// Agent type
type Agent struct {
}

// NewAgent creates a new instance
func NewAgent() *Agent {
	return &Agent{}
}

// Join join the host group under the management server
func (a *Agent) Join() {

}

// Heartbeat send a heartbeat to management server
func (a *Agent) Heartbeat() {

}

// Report report local actions to the management server
func (a *Agent) Report() {

}
