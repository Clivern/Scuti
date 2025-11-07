# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Module.LockModule do
  @moduledoc """
  Lock Module
  """
  alias Scuti.Context.LockContext

  @doc """
  Lock an entity
  """
  def lock_entity(entity, id \\ 0) do
    :sleeplocks.new(1, name: :scuti_lock)

    case :sleeplocks.attempt(:scuti_lock) do
      :ok ->
        lock =
          LockContext.new_lock(%{
            key: "#{entity}_#{id}",
            status: "locked"
          })

        case LockContext.create_lock(lock) do
          {:ok, lock} ->
            :sleeplocks.release(:scuti_lock)
            {:ok, lock}

          {:error, changeset} ->
            messages =
              changeset.errors()
              |> Enum.map(fn {field, {message, _options}} -> "#{field}: #{message}" end)

            {:error, Enum.at(messages, 0)}
        end

      {:error, :unavailable} ->
        {:error, "Unable to lock the entity"}
    end
  end

  @doc """
  Unlock an entity
  """
  def unlock_entity(entity, id \\ 0) do
    case LockContext.get_lock_by_key("#{entity}_#{id}") do
      nil ->
        false

      lock ->
        LockContext.delete_lock(lock)
    end
  end

  @doc """
  Check if an entity is locked
  """
  def is_locked(entity, id \\ 0) do
    case LockContext.get_lock_by_key("#{entity}_#{id}") do
      nil -> false
      lock -> lock.status == "locked"
    end
  end

  @doc """
  Release old locks
  """
  def release_locks(seconds_ago \\ -3600) do
    LockContext.release_locks(seconds_ago)
  end

  @doc """
  Delete old locks
  """
  def delete_locks(months_ago \\ -3) do
    LockContext.delete_locks(months_ago)
  end
end
