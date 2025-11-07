# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Module.HostGroupModule do
  @moduledoc """
  HostGroup Module
  """

  alias Scuti.Context.TeamContext
  alias Scuti.Context.UserContext
  alias Scuti.Context.HostGroupContext
  alias Scuti.Context.HostContext

  @doc """
  Create a group
  """
  def create_group(data \\ %{}) do
    group =
      HostGroupContext.new_group(%{
        name: data[:name],
        description: data[:description],
        secret_key: data[:secret_key],
        team_id: data[:team_id],
        labels: data[:labels],
        remote_join: data[:remote_join] || false
      })

    case HostGroupContext.create_group(group) do
      {:ok, group} ->
        {:ok, group}

      {:error, changeset} ->
        messages =
          changeset.errors()
          |> Enum.map(fn {field, {message, _options}} -> "#{field}: #{message}" end)

        {:error, Enum.at(messages, 0)}
    end
  end

  @doc """
  Update a group
  """
  def update_group(data \\ %{}) do
    case HostGroupContext.get_group_by_uuid(data[:uuid]) do
      nil ->
        {:not_found, "Group with ID #{data[:uuid]} not found"}

      group ->
        new_group = %{
          name: data[:name] || group.name,
          description: data[:description] || group.description,
          team_id: data[:team_id] || group.team_id,
          labels: data[:labels] || group.labels,
          remote_join: data[:remote_join] || false
        }

        case HostGroupContext.update_group(group, new_group) do
          {:ok, group} ->
            {:ok, group}

          {:error, changeset} ->
            messages =
              changeset.errors()
              |> Enum.map(fn {field, {message, _options}} -> "#{field}: #{message}" end)

            {:error, Enum.at(messages, 0)}
        end
    end
  end

  @doc """
  Get host groups
  """
  def get_groups(offset, limit) do
    HostGroupContext.get_groups(offset, limit)
  end

  @doc """
  Count host groups
  """
  def count_groups() do
    HostGroupContext.count_groups()
  end

  @doc """
  Get user host groups
  """
  def get_user_groups(user_id, offset, limit) do
    HostGroupContext.get_groups_by_teams(get_user_teams(user_id), offset, limit)
  end

  @doc """
  Get user host groups
  """
  def count_user_groups(user_id) do
    get_user_teams(user_id)
    |> count_groups_by_teams()
  end

  @doc """
  Get Host Group by ID
  """
  def get_group_by_id(id) do
    HostGroupContext.get_group_by_id(id)
  end

  @doc """
  Get Host Group by UUID
  """
  def get_group_by_uuid(uuid) do
    case HostGroupContext.get_group_by_uuid(uuid) do
      nil ->
        {:not_found, "Host group with ID #{uuid} not found"}

      group ->
        {:ok, group}
    end
  end

  @doc """
  Get Host Groups by Team List
  """
  def get_groups_by_teams(teams_ids, offset, limit) do
    HostGroupContext.get_groups_by_teams(teams_ids, offset, limit)
  end

  @doc """
  Get Host Groups by Team List
  """
  def get_groups_by_teams(teams_ids) do
    HostGroupContext.get_groups_by_teams(teams_ids)
  end

  @doc """
  Get User Teams
  """
  def get_user_teams(user_id) do
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

  @doc """
  Count host groups by team ids
  """
  def count_groups_by_teams(teams_ids) do
    HostGroupContext.count_groups_by_teams(teams_ids)
  end

  @doc """
  Validate Team ID
  """
  def validate_team_id(id) do
    TeamContext.validate_team_id(id)
  end

  @doc """
  Validate Team UUID
  """
  def validate_team_uuid(uuid) do
    TeamContext.validate_team_uuid(uuid)
  end

  @doc """
  Get group ID with UUID
  """
  def get_group_id_with_uuid(group_uuid) do
    HostGroupContext.get_group_id_with_uuid(group_uuid)
  end

  @doc """
  Count Hosts by Host Group
  """
  def count_hosts_by_host_group(group_id) do
    HostContext.count_hosts_by_host_group(group_id)
  end

  @doc """
  Delete a Group by UUID
  """
  def delete_group_by_uuid(uuid) do
    case HostGroupContext.get_group_by_uuid(uuid) do
      nil ->
        {:not_found, "Host group with ID #{uuid} not found"}

      group ->
        HostGroupContext.delete_group(group)
        {:ok, "Host group with ID #{uuid} deleted successfully"}
    end
  end
end
