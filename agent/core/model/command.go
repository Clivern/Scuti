// Copyright 2022 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package model

import (
	"github.com/clivern/scuti/agent/core/util"
)

// Command struct
type Command struct {
	DeploymentUUID        string `json:"deployment_uuid"`
	HostUUID              string `json:"host_uuid"`
	TaskUUID              string `json:"task_uuid"`
	PatchType             string `json:"patch_type"`
	PkgsToUpgrade         string `json:"pkgs_to_upgrade"`
	PkgsToExclude         string `json:"pkgs_to_exclude"`
	PrePatchScript        string `json:"pre_patch_script"`
	PatchScript           string `json:"patch_script"`
	PostPatchScript       string `json:"post_patch_script"`
	PostPatchRebootOption string `json:"post_patch_reboot_option"`
}

// LoadFromJSON update object from json
func (c *Command) LoadFromJSON(data []byte) error {
	return util.LoadFromJSON(c, data)
}

// ConvertToJSON convert object to json
func (c *Command) ConvertToJSON() (string, error) {
	return util.ConvertToJSON(c)
}
