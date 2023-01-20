# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.HostGroupContext do
  @moduledoc """
  HostGroup Context Module
  """

  import Ecto.Query

  alias Scuti.Repo
  alias Scuti.Model.{HostGroupMeta, HostGroup}

  @doc """
  Get a new host group
  """
  def new_group(group \\ %{}) do
    %{
      name: group.name,
      secret_key: group.secret_key,
      team_id: group.team_id,
      labels: group.labels,
      remote_join: group.remote_join,
      uuid: Ecto.UUID.generate()
    }
  end

  @doc """
  Get a host group meta
  """
  def new_meta(meta \\ %{}) do
    %{
      key: meta.key,
      value: meta.value,
      host_group_id: meta.host_group_id
    }
  end

  @doc """
  Create a new host group
  """
  def create_group(attrs \\ %{}) do
    %HostGroup{}
    |> HostGroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a host group by ID
  """
  def get_group_by_id(id) do
    Repo.get(HostGroup, id)
  end

  @doc """
  Get host group by UUID
  """
  def get_group_by_uuid(uuid) do
    from(
      h in HostGroup,
      where: h.uuid == ^uuid
    )
    |> Repo.one()
  end

  @doc """
  Update a host group
  """
  def update_group(group, attrs) do
    group
    |> HostGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a host group
  """
  def delete_group(group) do
    Repo.delete(group)
  end

  @doc """
  Retrieve all host groups
  """
  def get_groups() do
    Repo.all(HostGroup)
  end

  @doc """
  Retrieve host groups
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
  Retrieve host groups by team ids
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
  Count host groups by team ids
  """
  def count_groups_by_teams(teams_ids) do
    from(h in HostGroup,
      select: count(h.id),
      where: h.team_id in ^teams_ids
    )
    |> Repo.one()
  end

  @doc """
  Retrieve host groups by team id
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
  Create a new host group meta
  """
  def create_group_meta(attrs \\ %{}) do
    %HostGroupMeta{}
    |> HostGroupMeta.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a host group meta by id
  """
  def get_group_meta_by_id(id) do
    Repo.get(HostGroupMeta, id)
  end

  @doc """
  Update a host group meta
  """
  def update_group_meta(group_meta, attrs) do
    group_meta
    |> HostGroupMeta.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a host group meta
  """
  def delete_group_meta(group_meta) do
    Repo.delete(group_meta)
  end

  @doc """
  Get host group meta by group id and key
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
  Get host group metas
  """
  def get_group_metas(host_group_id) do
    from(
      h in HostGroupMeta,
      where: h.host_group_id == ^host_group_id
    )
    |> Repo.all()
  end
end
