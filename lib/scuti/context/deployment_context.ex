# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.DeploymentContext do
  @moduledoc """
  Deployment Context Module
  """

  import Ecto.Query

  alias Scuti.Repo
  alias Scuti.Model.{DeploymentMeta, Deployment, HostGroup, Host}

  @doc """
  Get a new deployment
  """
  def new_deployment(deployment \\ %{}) do
    %{
      team_id: deployment.team_id,
      name: deployment.name,
      hosts_filter: deployment.hosts_filter,
      host_groups_filter: deployment.host_groups_filter,
      patch_type: deployment.patch_type,
      pkgs_to_upgrade: deployment.pkgs_to_upgrade,
      pkgs_to_exclude: deployment.pkgs_to_exclude,
      pre_patch_script: deployment.pre_patch_script,
      patch_script: deployment.patch_script,
      post_patch_script: deployment.post_patch_script,
      post_patch_reboot_option: deployment.post_patch_reboot_option,
      rollout_strategy: deployment.rollout_strategy,
      rollout_strategy_value: deployment.rollout_strategy_value,
      schedule_type: deployment.schedule_type,
      schedule_time: deployment.schedule_time,
      last_status: deployment.last_status,
      last_run_at: deployment.last_run_at,
      uuid: Ecto.UUID.generate()
    }
  end

  @doc """
  Get a deployment meta
  """
  def new_meta(meta \\ %{}) do
    %{
      key: meta.key,
      value: meta.value,
      deployment_id: meta.deployment_id
    }
  end

  @doc """
  Create a new deployment
  """
  def create_deployment(attrs \\ %{}) do
    %Deployment{}
    |> Deployment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a deployment by ID
  """
  def get_deployment_by_id(id) do
    Repo.get(Deployment, id)
  end

  @doc """
  Get deployment by UUID
  """
  def get_deployment_by_uuid(uuid) do
    from(
      d in Deployment,
      where: d.uuid == ^uuid
    )
    |> Repo.one()
  end

  @doc """
  Get deployment target hosts by id
  """
  def get_deployment_target_hosts(id, teams_ids) do
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
        host_group_query = from(h in HostGroup, where: h.team_id in ^teams_ids)

        host_group_query =
          Enum.reduce(String.split(host_groups_filter, ","), host_group_query, fn tag, query ->
            items = String.split(tag, "=")
            flag = Enum.at(items, 0)
            value = Enum.at(items, 1)

            case flag do
              "name" ->
                from h in query, where: h.name == ^value

              _ ->
                from h in query, where: like(h.labels, ^tag)
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
                from h in query, where: like(h.labels, ^tag)
            end
          end)

        host_query |> Repo.all()
    end
  end

  @doc """
  Update a deployment
  """
  def update_deployment(deployment, attrs) do
    deployment
    |> Deployment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a deployment
  """
  def delete_deployment(deployment) do
    Repo.delete(deployment)
  end

  @doc """
  Retrieve all deployments
  """
  def get_deployments() do
    Repo.all(Deployment)
  end

  @doc """
  Retrieve deployments
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
  Retrieve deployments by team id
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
  Retrieve deployments by team ids
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
  Count deployments by team ids
  """
  def count_deployments_by_teams(teams_ids) do
    from(d in Deployment,
      select: count(d.id),
      where: d.team_id in ^teams_ids
    )
    |> Repo.one()
  end

  @doc """
  Create a new deployment meta
  """
  def create_deployment_meta(attrs \\ %{}) do
    %DeploymentMeta{}
    |> DeploymentMeta.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a deployment meta by id
  """
  def get_deployment_meta_by_id(id) do
    Repo.get(DeploymentMeta, id)
  end

  @doc """
  Update a deployment meta
  """
  def update_deployment_meta(deployment_meta, attrs) do
    deployment_meta
    |> DeploymentMeta.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a deployment meta
  """
  def delete_deployment_meta(deployment_meta) do
    Repo.delete(deployment_meta)
  end

  @doc """
  Get deployment meta by deployment id and key
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
  Get deployment metas
  """
  def get_deployment_metas(deployment_id) do
    from(
      d in DeploymentMeta,
      where: d.deployment_id == ^deployment_id
    )
    |> Repo.all()
  end
end
