# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Module.DeploymentModule do
  @moduledoc """
  Deployment Module
  """

  alias Scuti.Context.DeploymentContext
  alias Scuti.Context.UserContext

  @doc """
  Create a deployment
  """
  def create_deployment(data \\ %{}) do
    deployment =
      DeploymentContext.new_deployment(%{
        team_id: data[:team_id],
        name: data[:name],
        description: data[:description],
        hosts_filter: data[:hosts_filter],
        host_groups_filter: data[:host_groups_filter],
        patch_type: data[:patch_type],
        pre_patch_script: data[:pre_patch_script],
        patch_script: data[:patch_script],
        post_patch_script: data[:post_patch_script],
        post_patch_reboot_option: data[:post_patch_reboot_option],
        rollout_strategy: data[:rollout_strategy],
        rollout_strategy_value: data[:rollout_strategy_value],
        schedule_type: data[:schedule_type],
        schedule_time: data[:schedule_time],
        recurrence: data[:recurrence],
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
  Update a deployment
  """
  def update_deployment(data \\ %{}) do
    case DeploymentContext.get_deployment_by_uuid(data[:uuid]) do
      nil ->
        {:not_found, "Deployment with ID #{data[:uuid]} not found"}

      deployment ->
        new_deployment = %{
          name: data[:name] || deployment.name,
          description: data[:description] || deployment.description,
          hosts_filter: data[:hosts_filter] || deployment.hosts_filter,
          host_groups_filter: data[:host_groups_filter] || deployment.host_groups_filter,
          patch_type: data[:patch_type] || deployment.patch_type,
          pre_patch_script: data[:pre_patch_script] || deployment.pre_patch_script,
          patch_script: data[:patch_script] || deployment.patch_script,
          post_patch_script: data[:post_patch_script] || deployment.post_patch_script,
          post_patch_reboot_option:
            data[:post_patch_reboot_option] || deployment.post_patch_reboot_option,
          rollout_strategy: data[:rollout_strategy] || deployment.rollout_strategy,
          rollout_strategy_value:
            data[:rollout_strategy_value] || deployment.rollout_strategy_value,
          schedule_type: data[:schedule_type] || deployment.schedule_type,
          schedule_time: data[:schedule_time] || deployment.schedule_time,
          recurrence: data[:recurrence] || deployment.recurrence
        }

        case DeploymentContext.update_deployment(deployment, new_deployment) do
          {:ok, deployment} ->
            {:ok, deployment}

          {:error, changeset} ->
            messages =
              changeset.errors()
              |> Enum.map(fn {field, {message, _options}} -> "#{field}: #{message}" end)

            {:error, Enum.at(messages, 0)}
        end
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

  @doc """
  Get deployments with pagination
  """
  def get_deployments(offset, limit) do
    DeploymentContext.get_deployments(offset, limit)
  end

  @doc """
  Count deployments
  """
  def count_deployments() do
    DeploymentContext.count_deployments()
  end

  @doc """
  Get user deployments with pagination
  """
  def get_user_deployments(user_id, offset, limit) do
    DeploymentContext.get_deployments_by_teams(get_user_teams(user_id), offset, limit)
  end

  @doc """
  Count user deployments
  """
  def count_user_deployments(user_id) do
    DeploymentContext.count_deployments_by_teams(get_user_teams(user_id))
  end

  @doc """
  Delete a Deployment by UUID
  """
  def delete_deployment_by_uuid(uuid) do
    case DeploymentContext.get_deployment_by_uuid(uuid) do
      nil ->
        {:not_found, "Deployment with ID #{uuid} not found"}

      deployment ->
        DeploymentContext.delete_deployment(deployment)
        {:ok, "Deployment with ID #{uuid} deleted successfully"}
    end
  end

  defp get_user_teams(user_id) do
    teams = UserContext.get_user_teams(user_id)

    result = []

    for team <- teams do
      result ++
        %{
          id: team.id,
          uuid: team.uuid,
          name: team.name
        }
    end
  end
end
