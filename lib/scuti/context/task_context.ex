# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.TaskContext do
  @moduledoc """
  Task Context Module
  """

  import Ecto.Query

  alias Scuti.Repo
  alias Scuti.Model.{Task, TaskMeta, TaskLog}

  @doc """
  Get a new task
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
  Get a new task log
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
  Get a task meta
  """
  def new_meta(meta \\ %{}) do
    %{
      key: meta.key,
      value: meta.value,
      task_id: meta.task_id
    }
  end

  @doc """
  Create a new task
  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Create a new task log
  """
  def create_task_log(attrs \\ %{}) do
    %TaskLog{}
    |> TaskLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a task by ID
  """
  def get_task_by_id(id) do
    Repo.get(Task, id)
  end

  @doc """
  Get task by uuid
  """
  def get_task_by_uuid(uuid) do
    from(
      t in Task,
      where: t.uuid == ^uuid
    )
    |> Repo.one()
  end

  @doc """
  Get task log by host id and task id
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
  Get task logs by host id
  """
  def get_task_logs(task_id) do
    from(
      t in TaskLog,
      where: t.task_id == ^task_id
    )
    |> Repo.all()
  end

  @doc """
  Update a task
  """
  def update_task(task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Update a task log
  """
  def update_task_log(task, attrs) do
    task
    |> TaskLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a task
  """
  def delete_task(task) do
    Repo.delete(task)
  end

  @doc """
  Retrieve all tasks
  """
  def get_tasks() do
    Repo.all(Task)
  end

  @doc """
  Retrieve tasks
  """
  def get_tasks(offset, limit) do
    from(t in Task,
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Retrieve pending tasks
  """
  def get_pending_tasks() do
    from(t in Task,
      order_by: [desc: t.inserted_at],
      where: t.status == ^"pending"
    )
    |> Repo.all()
  end

  @doc """
  Retrieve deployment tasks
  """
  def get_deployment_tasks(deployment_id) do
    from(t in Task,
      order_by: [desc: t.inserted_at],
      where: t.deployment_id == ^deployment_id
    )
    |> Repo.all()
  end

  @doc """
  Create a new task meta
  """
  def create_task_meta(attrs \\ %{}) do
    %TaskMeta{}
    |> TaskMeta.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a task meta by id
  """
  def get_task_meta_by_id(id) do
    Repo.get(TaskMeta, id)
  end

  @doc """
  Update a task meta
  """
  def update_task_meta(task_meta, attrs) do
    task_meta
    |> TaskMeta.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a task meta
  """
  def delete_task_meta(task_meta) do
    Repo.delete(task_meta)
  end

  @doc """
  Get task meta by task id and key
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
  Get task metas
  """
  def get_task_metas(task_id) do
    from(
      t in TaskMeta,
      where: t.task_id == ^task_id
    )
    |> Repo.all()
  end

  @doc """
  Count updated hosts
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
  Count failed hosts
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
  Check if host updated successfully
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
  Check if host failed to update
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
