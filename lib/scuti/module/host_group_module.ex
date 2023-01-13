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

  @doc """
  Create a group
  """
  def create_group(data \\ %{}) do
    group =
      HostGroupContext.new_group(%{
        name: data[:name],
        api_key: data[:api_key],
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
  Get Host Groups by Team List
  """
  def get_groups_by_teams(teams_ids, offset, limit) do
    HostGroupContext.get_groups_by_teams(teams_ids, offset, limit)
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
end
