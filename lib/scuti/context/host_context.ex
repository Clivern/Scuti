# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.HostContext do
  @moduledoc """
  Host Context Module

  This module provides functions to manage hosts and their metadata
  within the application, including creation, retrieval, updating,
  and deletion of hosts and host metadata.
  """

  import Ecto.Query

  alias Scuti.Repo
  alias Scuti.Model.{HostMeta, Host}

  @doc """
  Create a new host with the given attributes.
  """
  def new_host(attrs \\ %{}) do
    %{
      name: attrs.name,
      hostname: attrs.hostname,
      host_group_id: attrs.host_group_id,
      labels: attrs.labels,
      agent_address: attrs.agent_address,
      status: attrs.status,
      reported_at: attrs.reported_at,
      secret_key: attrs.secret_key,
      uuid: Map.get(attrs, :uuid, Ecto.UUID.generate())
    }
  end

  @doc """
  Create a new host metadata entry with the given attributes.
  """
  def new_meta(attrs \\ %{}) do
    %{
      key: attrs.key,
      value: attrs.value,
      host_id: attrs.host_id
    }
  end

  @doc """
  Create a new host in the database.
  """
  def create_host(attrs \\ %{}) do
    %Host{}
    |> Host.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a host by its ID.
  """
  def get_host_by_id(id) do
    Repo.get(Host, id)
  end

  @doc """
  Validate if a host ID exists in the database.
  """
  def validate_host_id(id) do
    !!get_host_by_id(id)
  end

  @doc """
  Retrieve a host by its UUID.
  """
  def get_host_by_uuid(uuid) do
    from(
      h in Host,
      where: h.uuid == ^uuid
    )
    |> Repo.one()
  end

  @doc """
  Validate if a host UUID exists in the database.
  """
  def validate_host_uuid(uuid) do
    !!get_host_by_uuid(uuid)
  end

  @doc """
  Update an existing host with new attributes.
  """
  def update_host(host, attrs) do
    host
    |> Host.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a specified host from the database.
  """
  def delete_host(host) do
    Repo.delete(host)
  end

  @doc """
  Retrieve all hosts from the database.
  """
  def get_hosts() do
    Repo.all(Host)
  end

  @doc """
  Retrieve a paginated list of hosts from the database.
  """
  def get_hosts(offset, limit) do
    from(h in Host,
      order_by: [desc: h.inserted_at],
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Mark hosts as offline if they haven't sent a heartbeat within the specified time frame (in seconds).
  """
  def mark_hosts_as_offline(seconds) do
    older_than_one_minute = DateTime.utc_now() |> DateTime.add(-seconds)

    hosts_to_update =
      Repo.all(
        from h in Host,
          where: h.status != "offline",
          where: h.reported_at < ^older_than_one_minute
      )

    Enum.each(hosts_to_update, fn host ->
      host
      |> Host.changeset(%{status: "offline"})
      |> Repo.update()
    end)

    length(hosts_to_update)
  end

  @doc """
  Retrieve a host by its ID and team IDs.
  """
  def get_host_by_id_groups(id, groups_ids) do
    from(
      h in Host,
      where: h.id == ^id,
      where: h.host_group_id in ^groups_ids
    )
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Retrieve a host by its UUID and team IDs.
  """
  def get_host_by_uuid_groups(uuid, groups_ids) do
    from(
      h in Host,
      where: h.uuid == ^uuid,
      where: h.host_group_id in ^groups_ids
    )
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Retrieve all hosts associated with a specific host group ID.
  """
  def get_hosts_by_host_group(host_group_id, offset, limit) do
    from(h in Host,
      order_by: [desc: h.inserted_at],
      where: h.host_group_id == ^host_group_id,
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Count the number of hosts associated with a specific host group ID.
  """
  def count_hosts_by_host_group(host_group_id) do
    from(h in Host,
      select: count(h.id),
      where: h.host_group_id == ^host_group_id
    )
    |> Repo.one()
  end

  @doc """
  Create a new metadata entry for a host in the database.
  """
  def create_host_meta(attrs \\ %{}) do
    %HostMeta{}
    |> HostMeta.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a specific metadata entry by its ID.
  """
  def get_host_meta_by_id(id) do
    Repo.get(HostMeta, id)
  end

  @doc """
  Update an existing metadata entry with new attributes.
  """
  def update_host_meta(host_meta, attrs) do
    host_meta
    |> HostMeta.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a specified metadata entry from the database.
  """
  def delete_host_meta(host_meta) do
    Repo.delete(host_meta)
  end

  @doc """
  Retrieve specific metadata for a host by its ID and key.
  """
  def get_host_meta_by_id_key(host_id, meta_key) do
    from(
      h in HostMeta,
      where: h.host_id == ^host_id,
      where: h.key == ^meta_key
    )
    |> Repo.one()
  end

  @doc """
  Retrieve all metadata entries associated with a specific host ID.
  """
  def get_host_metas(host_id) do
    from(
      h in HostMeta,
      where: h.host_id == ^host_id
    )
    |> Repo.all()
  end
end
