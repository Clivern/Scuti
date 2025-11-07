# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.TaskContext do
  @moduledoc """
  Task Context Module

  This module provides functions to manage tasks, task logs, and task metadata
  within the application. It includes functionalities for creating, retrieving,
  updating, and deleting tasks and their associated logs and metadata.
  """

  import Ecto.Query

  alias Scuti.Repo
  alias Scuti.Model.{Task, TaskMeta, TaskLog}

  @doc """
  Create a new task with the given attributes.
  """
  def new_task(attrs \\ %{}) do
    %{
      payload: attrs.payload,
      result: attrs.result,
      status: attrs.status,
      deployment_id: attrs.deployment_id,
      run_at: attrs.run_at,
      uuid: Map.get(attrs, :uuid, Ecto.UUID.generate())
    }
  end

  @doc """
  Create a new task log with the given attributes.
  """
  def new_task_log(attrs \\ %{}) do
    %{
      host_id: attrs.host_id,
      task_id: attrs.task_id,
      type: attrs.type,
      record: attrs.record,
      uuid: Map.get(attrs, :uuid, Ecto.UUID.generate())
    }
  end

  @doc """
  Create a new task metadata entry.
  """
  def new_meta(meta \\ %{}) do
    %{
      key: meta.key,
      value: meta.value,
      task_id: meta.task_id
    }
  end

  @doc """
  Create a new task in the database.
  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Create a new task log in the database.
  """
  def create_task_log(attrs \\ %{}) do
    %TaskLog{}
    |> TaskLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a task by its ID.
  """
  def get_task_by_id(id) do
    Repo.get(Task, id)
  end

  @doc """
  Validate a task by its ID.
  """
  def validate_task_id(id) do
    !!get_task_by_id(id)
  end

  @doc """
  Retrieve a task by its UUID.
  """
  def get_task_by_uuid(uuid) do
    from(
      t in Task,
      where: t.uuid == ^uuid
    )
    |> Repo.one()
  end

  @doc """
  Validate a task by its UUID.
  """
  def validate_task_uuid(uuid) do
    !!get_task_by_uuid(uuid)
  end

  @doc """
  Retrieve a task log by host ID and task ID.
  """
  def get_task_log(host_id, task_id) do
    from(
      t in TaskLog,
      where: t.host_id == ^host_id,
      where: t.task_id == ^task_id
    )
    |> Repo.one()
  end

  @doc """
  Retrieve all logs associated with a specific task ID.
  """
  def get_task_logs(task_id) do
    from(
      t in TaskLog,
      where: t.task_id == ^task_id
    )
    |> Repo.all()
  end

  @doc """
  Update an existing task with new attributes.
  """
  def update_task(task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Update an existing task log with new attributes.
  """
  def update_task_log(task, attrs) do
    task
    |> TaskLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a specific task from the database.
  """
  def delete_task(task) do
    Repo.delete(task)
  end

  @doc """
  Retrieve all tasks from the database.
  """
  def get_tasks() do
    Repo.all(Task)
  end

  @doc """
  Retrieve a paginated list of tasks from the database.
  """
  def get_tasks(offset, limit) do
    from(t in Task,
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Retrieve all pending tasks ordered by their creation date.
  """
  def get_pending_tasks() do
    from(t in Task,
      order_by: [desc: t.inserted_at],
      where: t.status == ^"pending"
    )
    |> Repo.all()
  end

  @doc """
  Retrieve all tasks associated with a specific deployment ID.
  """
  def get_deployment_tasks(deployment_id) do
    from(t in Task,
      order_by: [desc: t.inserted_at],
      where: t.deployment_id == ^deployment_id
    )
    |> Repo.all()
  end

  @doc """
  Create a new metadata entry for a specific task in the database.
  """
  def create_task_meta(attrs \\ %{}) do
    %TaskMeta{}
    |> TaskMeta.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a specific metadata entry by its ID.
  """
  def get_task_meta_by_id(id) do
    Repo.get(TaskMeta, id)
  end

  @doc """
  Update an existing metadata entry with new attributes.
  """
  def update_task_meta(task_meta, attrs) do
    task_meta
    |> TaskMeta.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a specific metadata entry from the database.
  """
  def delete_task_meta(task_meta) do
    Repo.delete(task_meta)
  end

  @doc """
  Get specific metadata by its associated task ID and key.
  """
  def get_task_meta_by_id_key(task_id, meta_key) do
    from(
      t in TaskMeta,
      where: t.task_id == ^task_id,
      where: t.key == ^meta_key
    )
    |> Repo.one()
  end

  @doc """
  Get all metadata entries associated with a specific task ID.
  """
  def get_task_metas(task_id) do
    from(
      t in TaskMeta,
      where: t.task_id == ^task_id
    )
    |> Repo.all()
  end

  @doc """
  Count hosts that were updated successfully for a given task.
  """
  def count_updated_hosts(task_id) do
    from(t in TaskLog,
      select: count(t.id),
      where: t.task_id == ^task_id,
      where: t.type == ^"host_updated_successfully"
    )
    |> Repo.one()
  end

  @doc """
  Count hosts that failed to update for a given task.
  """
  def count_failed_hosts(task_id) do
    from(t in TaskLog,
      select: count(t.id),
      where: t.task_id == ^task_id,
      where: t.type == ^"host_failed_to_update"
    )
    |> Repo.one()
  end

  @doc """
  Check if a specific host was updated successfully for a given task.
  """
  def is_host_updated_successfully(host_id, task_id) do
    from(t in TaskLog,
      select: count(t.id),
      where: t.host_id == ^host_id,
      where: t.task_id == ^task_id,
      where: t.type == ^"host_updated_successfully"
    )
    |> Repo.one() > 0
  end

  @doc """
  Check if a specific host failed to update for a given task.
  """
  def is_host_failed_to_update(host_id, task_id) do
    from(t in TaskLog,
      select: count(t.id),
      where: t.host_id == ^host_id,
      where: t.task_id == ^task_id,
      where: t.type == ^"host_failed_to_update"
    )
    |> Repo.one() > 0
  end
end
