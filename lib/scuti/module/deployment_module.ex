# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Module.DeploymentModule do
  @moduledoc """
  Deployment Module
  """

  alias Scuti.Context.DeploymentContext

  @doc """
  Create a deployment
  """
  def create_deployment(data \\ %{}) do
    deployment =
      DeploymentContext.new_deployment(%{
        team_id: data[:team_id],
        name: data[:name],
        hosts_filter: data[:hosts_filter],
        host_groups_filter: data[:host_groups_filter],
        patch_type: data[:patch_type],
        pkgs_to_upgrade: data[:pkgs_to_upgrade],
        pkgs_to_exclude: data[:pkgs_to_exclude],
        pre_patch_script: data[:pre_patch_script],
        patch_script: data[:patch_script],
        post_patch_script: data[:post_patch_script],
        post_patch_reboot_option: data[:post_patch_reboot_option],
        rollout_strategy: data[:rollout_strategy],
        rollout_strategy_value: data[:rollout_strategy_value],
        schedule_type: data[:schedule_type],
        schedule_time: data[:schedule_time],
        last_status: data[:last_status],
        last_run_at: data[:last_run_at]
      })

    case DeploymentContext.create_deployment(deployment) do
      {:ok, deployment} ->
        {:ok, deployment}

      {:error, changeset} ->
        messages =
          changeset.errors()
          |> Enum.map(fn {field, {message, _options}} -> "#{field}: #{message}" end)

        {:error, Enum.at(messages, 0)}
    end
  end

  @doc """
  Update deployment status
  """
  def update_deployment_status(id, last_status) do
    deployment = get_deployment_by_id(id)

    case deployment do
      nil ->
        {:error, "Deployment with id #{id} not found"}

      _ ->
        DeploymentContext.update_deployment(deployment, %{
          last_status: last_status,
          last_run_at: DateTime.utc_now()
        })

        {:ok, "Deployment with id #{id} updated successfully"}
    end
  end

  @doc """
  Get Deployments by Team List
  """
  def get_deployments_by_teams(teams_ids, offset, limit) do
    DeploymentContext.get_deployments_by_teams(teams_ids, offset, limit)
  end

  @doc """
  Count Deployments by Team IDs
  """
  def count_deployments_by_teams(teams_ids) do
    DeploymentContext.count_deployments_by_teams(teams_ids)
  end

  @doc """
  Count Deployment by ID
  """
  def get_deployment_by_id(id) do
    DeploymentContext.get_deployment_by_id(id)
  end

  @doc """
  Count Deployment by UUID
  """
  def get_deployment_by_uuid(uuid) do
    DeploymentContext.get_deployment_by_uuid(uuid)
  end

  @doc """
  Get deployment target hosts by ID
  """
  def get_deployment_target_hosts(id) do
    DeploymentContext.get_deployment_target_hosts(id)
  end

  @doc """
  Retrieve pending deployments
  """
  def get_pending_once_deployments() do
    DeploymentContext.get_pending_once_deployments()
  end
end
