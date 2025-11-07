// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package module

import (
	"context"
	"fmt"

	"github.com/clivern/scuti/agent/core/model"
	"github.com/clivern/scuti/agent/core/service"

	"github.com/spf13/viper"
)

// Agent type
type Agent struct {
	ManagementAddress string
	HostGroupUUID     string
	HostGroupSecret   string
	HostUUID          string
	HostSecret        string

	httpClient *service.HttpClient
}

// JoinRequest type
type JoinRequest struct {
	Name         string
	Hostname     string
	AgentAddress string
	Labels       string
	AgentSecret  string
}

// HeartbeatRequest type
type HeartbeatRequest struct {
	Status string
}

type AgentEvent struct {
	Type     string
	Record   string
	TaskUUID string
}

// NewAgent creates a new instance
func NewAgent() *Agent {
	return &Agent{
		ManagementAddress: viper.GetString("agent.management.address"),
		HostGroupUUID:     viper.GetString("agent.management.host_group_uuid"),
		HostGroupSecret:   viper.GetString("agent.management.host_group_secret"),
		HostUUID:          viper.GetString("agent.management.host_uuid"),
		HostSecret:        viper.GetString("agent.management.host_secret"),
		httpClient:        service.NewHTTPClient(),
	}
}

// Join join the host group under the management server
func (a *Agent) Join(request JoinRequest) error {
	payload := fmt.Sprintf(
		`{"name":"%s","hostname":"%s","agent_address":"%s","labels":"%s","agent_secret":"%s"}`,
		request.Name,
		request.Hostname,
		request.AgentAddress,
		request.Labels,
		request.AgentSecret,
	)

	webhookToken := a.Encrypt64(a.HostGroupSecret, payload)

	endpoint := fmt.Sprintf(
		"%s/action/v1/agent/join/%s/%s",
		service.RemoveTrailingSlash(a.ManagementAddress),
		a.HostGroupUUID,
		a.HostUUID,
	)

	response, err := a.httpClient.Post(
		context.TODO(),
		endpoint,
		payload,
		map[string]string{},
		map[string]string{
			"Content-Type":    "application/json",
			"X-Webhook-Token": webhookToken,
		},
	)

	if err != nil {
		return err
	}

	statusCode := a.httpClient.GetStatusCode(response)
	textResponse, _ := a.httpClient.ToString(response)

	if statusCode >= 400 {
		return fmt.Errorf("Error response: %s, status code %d", textResponse, statusCode)
	}

	return nil
}

// Heartbeat send a heartbeat to management server
func (a *Agent) Heartbeat(request HeartbeatRequest) error {
	payload := fmt.Sprintf(`{"status":"%s"}`, request.Status)

	webhookToken := a.Encrypt64(a.HostSecret, payload)

	endpoint := fmt.Sprintf(
		"%s/action/v1/agent/heartbeat/%s/%s",
		service.RemoveTrailingSlash(a.ManagementAddress),
		a.HostGroupUUID,
		a.HostUUID,
	)

	response, err := a.httpClient.Post(
		context.TODO(),
		endpoint,
		payload,
		map[string]string{},
		map[string]string{
			"Content-Type":    "application/json",
			"X-Webhook-Token": webhookToken,
		},
	)

	if err != nil {
		return err
	}

	statusCode := a.httpClient.GetStatusCode(response)
	textResponse, _ := a.httpClient.ToString(response)

	if statusCode >= 400 {
		return fmt.Errorf("Error response: %s, status code %d", textResponse, statusCode)
	}

	return nil
}

// Report report local actions to the management server
func (a *Agent) Report(event AgentEvent) error {
	payload := fmt.Sprintf(`{"type":"%s","record":"%s"}`, event.Type, event.Record)

	webhookToken := a.Encrypt64(a.HostSecret, payload)

	endpoint := fmt.Sprintf(
		"%s/action/v1/agent/report/%s/%s/%s",
		service.RemoveTrailingSlash(a.ManagementAddress),
		a.HostGroupUUID,
		a.HostUUID,
		event.TaskUUID,
	)

	response, err := a.httpClient.Post(
		context.TODO(),
		endpoint,
		payload,
		map[string]string{},
		map[string]string{
			"Content-Type":    "application/json",
			"X-Webhook-Token": webhookToken,
		},
	)

	if err != nil {
		return err
	}

	statusCode := a.httpClient.GetStatusCode(response)
	textResponse, _ := a.httpClient.ToString(response)

	if statusCode >= 400 {
		return fmt.Errorf("Error response: %s, status code %d", textResponse, statusCode)
	}

	return nil
}

// ValidateManagementRequest validates incoming request
func (a *Agent) ValidateManagementCommandRequest(cmd model.Command, token string) bool {
	payload := fmt.Sprintf(
		`{"deployment_uuid":"%s","host_uuid":"%s","task_uuid":"%s","patch_type":"%s","pre_patch_script":"%s","patch_script":"%s","post_patch_script":"%s","post_patch_reboot_option":"%s"}`,
		cmd.DeploymentUUID,
		cmd.HostUUID,
		cmd.TaskUUID,
		cmd.PatchType,
		cmd.PrePatchScript,
		cmd.PatchScript,
		cmd.PostPatchScript,
		cmd.PostPatchRebootOption,
	)

	return a.Encrypt64(a.HostSecret, payload) == token
}

// Encrypt64 create encrypted version of a data
func (a *Agent) Encrypt64(key, data string) string {
	return service.Base64Encrypt(key, data)
}
