# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Module.TeamModule do
  @moduledoc """
  Team Module
  """

  alias Scuti.Context.TeamContext
  alias Scuti.Context.UserContext

  @doc """
  Create a team
  """
  def create_team(data \\ %{}) do
    team =
      TeamContext.new_team(%{
        name: data[:name],
        description: data[:description]
      })

    case TeamContext.create_team(team) do
      {:ok, team} ->
        {:ok, team}

      {:error, changeset} ->
        messages =
          changeset.errors()
          |> Enum.map(fn {field, {message, _options}} -> "#{field}: #{message}" end)

        {:error, Enum.at(messages, 0)}
    end
  end

  @doc """
  Sync team members
  """
  def sync_team_members(team_id, future_members \\ []) do
    # Get current member IDs
    current_member_ids =
      UserContext.get_team_users(team_id)
      |> Enum.map(& &1.id)

    # Get future member IDs
    future_member_ids =
      future_members
      |> Enum.map(&get_user_id_with_uuid/1)
      |> Enum.reject(&is_nil/1)

    # Find members to remove (in current but not in future)
    members_to_remove = current_member_ids -- future_member_ids

    # Find members to add (in future but not in current)
    members_to_add = future_member_ids -- current_member_ids

    # Track results
    results = %{
      added: [],
      removed: [],
      errors: []
    }

    # Remove members
    results =
      Enum.reduce(members_to_remove, results, fn member_id, acc ->
        case UserContext.remove_user_from_team(member_id, team_id) do
          {:ok, _} -> %{acc | removed: [member_id | acc.removed]}
          {:error, reason} -> %{acc | errors: [{:remove, member_id, reason} | acc.errors]}
        end
      end)

    # Add members
    results =
      Enum.reduce(members_to_add, results, fn member_id, acc ->
        case UserContext.add_user_to_team(member_id, team_id) do
          {:ok, _} -> %{acc | added: [member_id | acc.added]}
          {:error, reason} -> %{acc | errors: [{:add, member_id, reason} | acc.errors]}
        end
      end)

    # Return results
    case results.errors do
      [] -> {:ok, results}
      _errors -> {:error, results}
    end
  end

  @doc """
  Get team members
  """
  def get_team_members(team_id) do
    UserContext.get_team_users(team_id)
    |> Enum.map(& &1.uuid)
  end

  @doc """
  Update a team
  """
  def update_team(data \\ %{}) do
    case TeamContext.get_team_by_uuid(data[:uuid]) do
      nil ->
        {:not_found, "Team with ID #{data[:uuid]} not found"}

      team ->
        new_team = %{
          name: data[:name] || team.name,
          description: data[:description] || team.description
        }

        case TeamContext.update_team(team, new_team) do
          {:ok, team} ->
            {:ok, team}

          {:error, changeset} ->
            messages =
              changeset.errors()
              |> Enum.map(fn {field, {message, _options}} -> "#{field}: #{message}" end)

            {:error, Enum.at(messages, 0)}
        end
    end
  end

  @doc """
  Get team by an id
  """
  def get_team_by_id(id) do
    case TeamContext.get_team_by_id(id) do
      nil ->
        {:not_found, "Team with ID #{id} not found"}

      team ->
        {:ok, team}
    end
  end

  @doc """
  Get team by UUID
  """
  def get_team_by_uuid(uuid) do
    case TeamContext.get_team_by_uuid(uuid) do
      nil ->
        {:not_found, "Team with ID #{uuid} not found"}

      team ->
        {:ok, team}
    end
  end

  @doc """
  Count Teams
  """
  def count_teams() do
    TeamContext.count_teams()
  end

  @doc """
  Count User Teams
  """
  def count_user_teams(user_id) do
    length(get_user_teams(user_id))
  end

  @doc """
  Get user teams
  """
  def get_user_teams(user_id) do
    UserContext.get_user_teams(user_id)
  end

  @doc """
  Get teams
  """
  def get_teams(offset, limit) do
    TeamContext.get_teams(offset, limit)
  end

  @doc """
  Get teams
  """
  def get_user_teams(user_id, offset, limit) do
    teams_ids =
      get_user_teams(user_id)
      |> Enum.map(& &1.id)

    TeamContext.get_teams(teams_ids, offset, limit)
  end

  @doc """
  Delete a Team by UUID
  """
  def delete_team_by_uuid(uuid) do
    case TeamContext.get_team_by_uuid(uuid) do
      nil ->
        {:not_found, "Team with ID #{uuid} not found"}

      team ->
        TeamContext.delete_team(team)
        {:ok, "Team with ID #{uuid} deleted successfully"}
    end
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
  Get Team ID with UUID
  """
  def get_team_id_with_uuid(uuid) do
    TeamContext.get_team_id_with_uuid(uuid)
  end

  @doc """
  Get Team UUID with ID
  """
  def get_team_uuid_with_id(id) do
    TeamContext.get_team_uuid_with_id(id)
  end

  @doc """
  Get User ID with UUID
  """
  def get_user_id_with_uuid(uuid) do
    UserContext.get_user_id_with_uuid(uuid)
  end
end
