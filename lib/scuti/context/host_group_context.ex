# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.HostGroupContext do
  @moduledoc """
  HostGroup Context Module

  This Module used for managing host groups and their metadata.
  This module provides functions to create, retrieve, update, and delete
  host groups and their associated metadata.
  """

  import Ecto.Query

  alias Scuti.Repo
  alias Scuti.Model.{HostGroupMeta, HostGroup}

  @doc """
  Create a new host group with the given attributes.
  """
  def new_group(attrs \\ %{}) do
    %{
      name: attrs.name,
      secret_key: attrs.secret_key,
      description: attrs.description,
      team_id: attrs.team_id,
      labels: attrs.labels,
      remote_join: attrs.remote_join,
      uuid: Map.get(attrs, :uuid, Ecto.UUID.generate())
    }
  end

  @doc """
  Create a new host group meta with the given attributes.
  """
  def new_meta(attrs \\ %{}) do
    %{
      key: attrs.key,
      value: attrs.value,
      host_group_id: attrs.host_group_id
    }
  end

  @doc """
  Create a new host group in the database.
  """
  def create_group(attrs \\ %{}) do
    %HostGroup{}
    |> HostGroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a host group by its ID.
  """
  def get_group_by_id(id) do
    Repo.get(HostGroup, id)
  end

  @doc """
  Retrieves a group's ID using its UUID.
  """
  def get_group_id_with_uuid(uuid) do
    case get_group_by_uuid(uuid) do
      nil -> nil
      group -> group.id
    end
  end

  @doc """
  Validate if a host group ID exists in the database.
  """
  def validate_group_id(id) do
    !!get_group_by_id(id)
  end

  @doc """
  Get a host group by its UUID.
  """
  def get_group_by_uuid(uuid) do
    from(
      h in HostGroup,
      where: h.uuid == ^uuid
    )
    |> Repo.one()
  end

  @doc """
  Validate if a host group UUID exists in the database.
  """
  def validate_group_uuid(uuid) do
    !!get_group_by_uuid(uuid)
  end

  @doc """
  Retrieve a host group by its ID and team IDs.
  """
  def get_group_by_id_teams(id, teams_ids) do
    from(
      h in HostGroup,
      where: h.id == ^id,
      where: h.team_id in ^teams_ids
    )
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Retrieve a host group by its UUID and team IDs.
  """
  def get_group_by_uuid_teams(uuid, teams_ids) do
    from(
      h in HostGroup,
      where: h.uuid == ^uuid,
      where: h.team_id in ^teams_ids
    )
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Update an existing host group with new attributes.
  """
  def update_group(group, attrs) do
    group
    |> HostGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a specified host group from the database.
  """
  def delete_group(group) do
    Repo.delete(group)
  end

  @doc """
  Retrieve all host groups from the database.
  """
  def get_groups() do
    Repo.all(HostGroup)
  end

  @doc """
  Retrieve a paginated list of host groups with an offset and limit.
  """
  def get_groups(offset, limit) do
    from(h in HostGroup,
      order_by: [desc: h.inserted_at],
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Retrieve host groups associated with specific team IDs in a paginated format.
  """
  def get_groups_by_teams(teams_ids, offset, limit) do
    from(h in HostGroup,
      order_by: [desc: h.inserted_at],
      where: h.team_id in ^teams_ids,
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Retrieve host groups associated with specific team IDs
  """
  def get_groups_by_teams(teams_ids) do
    from(h in HostGroup,
      order_by: [desc: h.inserted_at],
      where: h.team_id in ^teams_ids
    )
    |> Repo.all()
  end

  @doc """
  Count total number of host groups in the database.
  """
  def count_groups() do
    from(h in HostGroup,
      select: count(h.id)
    )
    |> Repo.one()
  end

  @doc """
  Count total number of host groups associated with specific team IDs.
  """
  def count_groups_by_teams(teams_ids) do
    from(h in HostGroup,
      select: count(h.id),
      where: h.team_id in ^teams_ids
    )
    |> Repo.one()
  end

  @doc """
  Retrieve a paginated list of host groups associated with a specific team ID.
  """
  def get_groups_by_team(team_id, offset, limit) do
    from(h in HostGroup,
      order_by: [desc: h.inserted_at],
      where: h.team_id == ^team_id,
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Create a new host group meta entry in the database with given attributes.
  """
  def create_group_meta(attrs \\ %{}) do
    %HostGroupMeta{}
    |> HostGroupMeta.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a specific host group meta entry by its ID.
  """
  def get_group_meta_by_id(id) do
    Repo.get(HostGroupMeta, id)
  end

  @doc """
  Update an existing host group meta entry with new attributes.
  """
  def update_group_meta(group_meta, attrs) do
    group_meta
    |> HostGroupMeta.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a specified host group meta entry from the database.
  """
  def delete_group_meta(group_meta) do
    Repo.delete(group_meta)
  end

  @doc """
  Get a specific host group meta entry by its associated group ID and key.
  """
  def get_group_meta_by_id_key(host_group_id, meta_key) do
    from(
      h in HostGroupMeta,
      where: h.host_group_id == ^host_group_id,
      where: h.key == ^meta_key
    )
    |> Repo.one()
  end

  @doc """
  Retrieve all metadata entries associated with a specific host group ID.
  """
  def get_group_metas(host_group_id) do
    from(
      h in HostGroupMeta,
      where: h.host_group_id == ^host_group_id
    )
    |> Repo.all()
  end
end
