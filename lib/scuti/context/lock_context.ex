# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.LockContext do
  @moduledoc """
  Lock Context Module
  """

  import Ecto.Query

  alias Scuti.Repo
  alias Scuti.Model.Lock

  @doc """
  Initializes a new lock with given attributes.
  """
  def new_lock(attrs \\ %{}) do
    %{
      uuid: Map.get(attrs, :uuid, Ecto.UUID.generate()),
      key: attrs.key,
      status: attrs.status
    }
  end

  @doc """
  Creates and saves a new lock to the database.
  """
  def create_lock(attrs \\ %{}) do
    %Lock{}
    |> Lock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieves a lock by its ID.
  """
  def get_lock_by_id(id) do
    Repo.get(Lock, id)
  end

  @doc """
  Retrieves a lock by its UUID.
  """
  def get_lock_by_uuid(uuid) do
    from(
      l in Lock,
      where: l.uuid == ^uuid
    )
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Retrieves a lock by its key.
  """
  def get_lock_by_key(key) do
    from(
      l in Lock,
      where: l.key == ^key
    )
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Updates an existing lock with new attributes.
  """
  def update_lock(lock, attrs) do
    lock
    |> Lock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a specified lock from the database.
  """
  def delete_lock(lock) do
    Repo.delete(lock)
  end

  @doc """
  Release old locks
  """
  def release_locks(seconds_ago \\ -3600) do
    one_hour_ago = DateTime.utc_now() |> DateTime.add(seconds_ago)

    from(l in Lock,
      where: l.updated_at < ^one_hour_ago,
      update: [set: [status: "released"]]
    )
    |> Repo.update_all([])
  end

  @doc """
  Delete old locks
  """
  def delete_locks(months_ago \\ -3) do
    three_months_ago = DateTime.utc_now() |> DateTime.add(months_ago * 30 * 24 * 60 * 60)

    from(l in Lock,
      where: l.updated_at < ^three_months_ago
    )
    |> Repo.delete_all()
  end
end
