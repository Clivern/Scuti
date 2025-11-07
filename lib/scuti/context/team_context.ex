# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.TeamContext do
  @moduledoc """
  Team Context Module

  Manages teams and their metadata, providing functions for CRUD operations.
  """

  import Ecto.Query

  alias Scuti.Repo
  alias Scuti.Model.{Team, TeamMeta}

  @doc """
  Initializes a new team with given attributes. Generates a UUID if not provided.
  """
  def new_team(attrs \\ %{}) do
    %{
      name: attrs.name,
      description: attrs.description,
      uuid: Map.get(attrs, :uuid, Ecto.UUID.generate())
    }
  end

  @doc """
  Initializes new team metadata.
  """
  def new_meta(meta \\ %{}) do
    %{
      key: meta.key,
      value: meta.value,
      team_id: meta.team_id
    }
  end

  @doc """
  Creates and saves a new team.
  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieves a team's ID using its UUID.
  """
  def get_team_id_with_uuid(uuid) do
    case get_team_by_uuid(uuid) do
      nil -> nil
      team -> team.id
    end
  end

  @doc """
  Retrieves a team's UUID using its ID.
  """
  def get_team_uuid_with_id(id) do
    case get_team_by_id(id) do
      nil -> nil
      team -> team.uuid
    end
  end

  @doc """
  Fetches a team by its ID.
  """
  def get_team_by_id(id) do
    Repo.get(Team, id)
  end

  @doc """
  Validates if a team ID exists.
  """
  def validate_team_id(id) do
    !!get_team_by_id(id)
  end

  @doc """
  Validates if a team UUID exists.
  """
  def validate_team_uuid(uuid) do
    !!get_team_by_uuid(uuid)
  end

  @doc """
  Fetches a team by its UUID.
  """
  def get_team_by_uuid(uuid) do
    from(
      t in Team,
      where: t.uuid == ^uuid
    )
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Updates an existing team's attributes.
  """
  def update_team(team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a specified team.
  """
  def delete_team(team) do
    Repo.delete(team)
  end

  @doc """
  Retrieves all teams.
  """
  def get_teams() do
    Repo.all(Team)
  end

  @doc """
  Retrieves teams with pagination.
  """
  def get_teams(offset, limit) do
    from(t in Team,
      order_by: [desc: t.inserted_at],
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Retrieves specific teams by IDs with pagination.
  """
  def get_teams(teams_ids, offset, limit) do
    from(t in Team,
      order_by: [desc: t.inserted_at],
      where: t.id in ^teams_ids,
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Counts all teams in the database.
  """
  def count_teams() do
    from(
      t in Team,
      select: count(t.id)
    )
    |> Repo.one()
  end

  @doc """
  Creates and saves new team metadata.
  """
  def create_team_meta(attrs \\ %{}) do
    %TeamMeta{}
    |> TeamMeta.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieves team metadata by its ID.
  """
  def get_team_meta_by_id(id) do
    Repo.get(TeamMeta, id)
  end

  @doc """
  Updates an existing team's metadata.
  """
  def update_team_meta(team_meta, attrs) do
    team_meta
    |> TeamMeta.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes specified team metadata.
  """
  def delete_team_meta(team_meta) do
    Repo.delete(team_meta)
  end

  @doc """
  Retrieves team metadata by team ID and key.
  """
  def get_team_meta_by_id_key(team_id, meta_key) do
    from(t in TeamMeta,
      where: t.team_id == ^team_id,
      where: t.key == ^meta_key
    )
    |> Repo.one()
  end

  @doc """
  Retrieves all metadata for a specific team.
  """
  def get_team_metas(team_id) do
    from(t in TeamMeta,
      where: t.team_id == ^team_id
    )
    |> Repo.all()
  end
end
