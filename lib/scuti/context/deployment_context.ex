# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.DeploymentContext do
  @moduledoc """
  Deployment Context Module

  This module is used for managing deployments and their metadata.
  This module provides functions to create, retrieve, update, and delete
  deployments and their associated metadata.
  """

  import Ecto.Query

  alias Scuti.Repo
  alias Scuti.Model.{DeploymentMeta, Deployment, HostGroup, Host}

  @doc """
  Create a new deployment with the given attributes.
  """
  def new_deployment(attrs \\ %{}) do
    %{
      team_id: attrs.team_id,
      name: attrs.name,
      description: attrs.description,
      hosts_filter: attrs.hosts_filter,
      host_groups_filter: attrs.host_groups_filter,
      patch_type: attrs.patch_type,
      pre_patch_script: attrs.pre_patch_script,
      patch_script: attrs.patch_script,
      post_patch_script: attrs.post_patch_script,
      post_patch_reboot_option: attrs.post_patch_reboot_option,
      rollout_strategy: attrs.rollout_strategy,
      rollout_strategy_value: attrs.rollout_strategy_value,
      schedule_type: attrs.schedule_type,
      schedule_time: attrs.schedule_time,
      recurrence: attrs.recurrence,
      last_status: attrs.last_status,
      last_run_at: attrs.last_run_at,
      uuid: Map.get(attrs, :uuid, Ecto.UUID.generate())
    }
  end

  @doc """
  Create a new deployment meta with the given attributes.
  """
  def new_meta(attrs \\ %{}) do
    %{
      key: attrs.key,
      value: attrs.value,
      deployment_id: attrs.deployment_id
    }
  end

  @doc """
  Create a new deployment in the database.
  """
  def create_deployment(attrs \\ %{}) do
    %Deployment{}
    |> Deployment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a deployment by its ID.
  """
  def get_deployment_by_id(id) do
    Repo.get(Deployment, id)
  end

  @doc """
  Validate if a deployment ID exists in the database.
  """
  def validate_deployment_id(id) do
    !!get_deployment_by_id(id)
  end

  @doc """
  Get a deployment by its UUID.
  """
  def get_deployment_by_uuid(uuid) do
    from(
      d in Deployment,
      where: d.uuid == ^uuid
    )
    |> Repo.one()
  end

  @doc """
  Validate if a deployment UUID exists in the database.
  """
  def validate_deployment_uuid(uuid) do
    !!get_deployment_by_uuid(uuid)
  end

  @doc """
  Retrieve a deployment by its ID and team IDs.
  """
  def get_deployment_by_id_teams(id, teams_ids) do
    from(
      d in Deployment,
      where: d.id == ^id,
      where: d.team_id in ^teams_ids
    )
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Retrieve a deployment by its UUID and team IDs.
  """
  def get_deployment_by_uuid_teams(uuid, teams_ids) do
    from(
      d in Deployment,
      where: d.uuid == ^uuid,
      where: d.team_id in ^teams_ids
    )
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Get target hosts for a specific deployment by its ID.
  """
  def get_deployment_target_hosts(id) do
    deployment = get_deployment_by_id(id)

    case deployment do
      nil ->
        nil

      _ ->
        hosts_filter =
          if deployment.hosts_filter == nil do
            ""
          else
            deployment.hosts_filter
          end

        host_groups_filter =
          if deployment.host_groups_filter == nil do
            ""
          else
            deployment.host_groups_filter
          end

        # Get a list of host groups
        host_group_query = from(h in HostGroup, where: h.team_id in ^[deployment.team_id])

        host_group_query =
          Enum.reduce(String.split(host_groups_filter, ","), host_group_query, fn tag, query ->
            items = String.split(tag, "=")
            flag = Enum.at(items, 0)
            value = Enum.at(items, 1)

            case flag do
              "name" ->
                from h in query, where: h.name == ^value

              _ ->
                from h in query, where: like(h.labels, ^"%#{tag}%")
            end
          end)

        host_groups_ids = Enum.map(host_group_query |> Repo.all(), fn obj -> obj.id end)

        host_query = from(h in Host, where: h.host_group_id in ^host_groups_ids)

        host_query =
          Enum.reduce(String.split(hosts_filter, ","), host_query, fn tag, query ->
            items = String.split(tag, "=")
            flag = Enum.at(items, 0)
            value = Enum.at(items, 1)

            case flag do
              "name" ->
                from h in query, where: h.name == ^value

              "hostname" ->
                from h in query, where: h.hostname == ^value

              _ ->
                from h in query, where: like(h.labels, ^"%#{tag}%")
            end
          end)

        host_query |> Repo.all()
    end
  end

  @doc """
  Update an existing deployment with new attributes.
  """
  def update_deployment(deployment, attrs) do
    deployment
    |> Deployment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a specified deployment from the database.
  """
  def delete_deployment(deployment) do
    Repo.delete(deployment)
  end

  @doc """
  Retrieve all deployments from the database.
  """
  def get_deployments() do
    Repo.all(Deployment)
  end

  @doc """
  Get deployment by UUID with locking
  """
  def get_deployment_by_uuid_with_locking(uuid) do
    from(
      d in Deployment,
      where: d.uuid == ^uuid
    )
    |> lock("FOR UPDATE")
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Retrieve a paginated list of deployments with an offset and limit.
  """
  def get_deployments(offset, limit) do
    from(d in Deployment,
      order_by: [desc: d.inserted_at],
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Retrieve deployments associated with a specific team ID in a paginated format.
  """
  def get_deployments_by_team(team_id, offset, limit) do
    from(d in Deployment,
      where: d.team_id == ^team_id,
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Retrieve deployments associated with specific team IDs in a paginated format.
  """
  def get_deployments_by_teams(teams_ids, offset, limit) do
    from(d in Deployment,
      order_by: [desc: d.inserted_at],
      where: d.team_id in ^teams_ids,
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Retrieve pending deployments scheduled for once type execution.
  """
  def get_pending_once_deployments() do
    from(d in Deployment,
      where: d.last_status == ^"unknown",
      where: d.schedule_type == ^"once",
      where: d.schedule_time < ^DateTime.utc_now()
    )
    |> Repo.all()
  end

  @doc """
  Count total number of deployments in the database.
  """
  def count_deployments() do
    from(d in Deployment,
      select: count(d.id)
    )
    |> Repo.one()
  end

  @doc """
  Count total number of deployments associated with specific team IDs.
  """
  def count_deployments_by_teams(teams_ids) do
    from(d in Deployment,
      select: count(d.id),
      where: d.team_id in ^teams_ids
    )
    |> Repo.one()
  end

  @doc """
  Create a new deployment meta entry in the database with given attributes.
  """
  def create_deployment_meta(attrs \\ %{}) do
    %DeploymentMeta{}
    |> DeploymentMeta.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a specific deployment meta entry by its ID.
  """
  def get_deployment_meta_by_id(id) do
    Repo.get(DeploymentMeta, id)
  end

  @doc """
  Update an existing deployment meta entry with new attributes.
  """
  def update_deployment_meta(deployment_meta, attrs) do
    deployment_meta
    |> DeploymentMeta.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a specified deployment meta entry from the database.
  """
  def delete_deployment_meta(deployment_meta) do
    Repo.delete(deployment_meta)
  end

  @doc """
  Get a specific deployment meta entry by its associated deployment ID and key.
  """
  def get_deployment_meta_by_id_key(deployment_id, meta_key) do
    from(
      d in DeploymentMeta,
      where: d.deployment_id == ^deployment_id,
      where: d.key == ^meta_key
    )
    |> Repo.one()
  end

  @doc """
  Retrieve all metadata entries associated with a specific deployment ID.
  """
  def get_deployment_metas(deployment_id) do
    from(
      d in DeploymentMeta,
      where: d.deployment_id == ^deployment_id
    )
    |> Repo.all()
  end
end
