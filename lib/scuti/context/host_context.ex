# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.HostContext do
  @moduledoc """
  Host Context Module
  """

  import Ecto.Query

  alias Scuti.Repo
  alias Scuti.Model.{HostMeta, Host}

  @doc """
  Get a new host
  """
  def new_host(host \\ %{}) do
    %{
      name: host.name,
      hostname: host.hostname,
      host_group_id: host.host_group_id,
      labels: host.labels,
      agent_address: host.agent_address,
      status: host.status,
      reported_at: host.reported_at,
      secret_key: host.secret_key,
      uuid: Ecto.UUID.generate()
    }
  end

  @doc """
  Get a host meta
  """
  def new_meta(meta \\ %{}) do
    %{
      key: meta.key,
      value: meta.value,
      host_id: meta.host_id
    }
  end

  @doc """
  Create a new host
  """
  def create_host(attrs \\ %{}) do
    %Host{}
    |> Host.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a host by ID
  """
  def get_host_by_id(id) do
    Repo.get(Host, id)
  end

  @doc """
  Get host by UUID
  """
  def get_host_by_uuid(uuid) do
    from(
      h in Host,
      where: h.uuid == ^uuid
    )
    |> Repo.one()
  end

  @doc """
  Update a host
  """
  def update_host(host, attrs) do
    host
    |> Host.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a host
  """
  def delete_host(host) do
    Repo.delete(host)
  end

  @doc """
  Retrieve all hosts
  """
  def get_hosts() do
    Repo.all(Host)
  end

  @doc """
  Retrieve hosts
  """
  def get_hosts(offset, limit) do
    from(h in Host,
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Get host as down if x seconds has passed and agent didn't send any
  heartbeat
  """
  def mark_hosts_down(seconds) do
    older_than_one_minute = DateTime.utc_now() |> DateTime.add(-seconds)

    hosts_to_update =
      Repo.all(
        from h in Host,
          where: h.status != "down",
          where: h.reported_at < ^older_than_one_minute
      )

    Enum.each(hosts_to_update, fn host ->
      host
      |> Host.changeset(%{status: "down"})
      |> Repo.update()
    end)

    length(hosts_to_update)
  end

  @doc """
  Retrieve hosts by host group id
  """
  def get_hosts_by_host_group(host_group_id, offset, limit) do
    from(h in Host,
      where: h.host_group_id == ^host_group_id,
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Count hosts by host group id
  """
  def count_hosts_by_host_group(host_group_id) do
    from(h in Host,
      select: count(h.id),
      where: h.host_group_id == ^host_group_id
    )
    |> Repo.one()
  end

  @doc """
  Create a new host meta
  """
  def create_host_meta(attrs \\ %{}) do
    %HostMeta{}
    |> HostMeta.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a host meta by id
  """
  def get_host_meta_by_id(id) do
    Repo.get(HostMeta, id)
  end

  @doc """
  Update a host meta
  """
  def update_host_meta(host_meta, attrs) do
    host_meta
    |> HostMeta.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a host meta
  """
  def delete_host_meta(host_meta) do
    Repo.delete(host_meta)
  end

  @doc """
  Get host meta by host id and key
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
  Get host metas
  """
  def get_host_metas(host_id) do
    from(
      h in HostMeta,
      where: h.host_id == ^host_id
    )
    |> Repo.all()
  end
end
