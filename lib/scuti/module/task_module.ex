# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Module.TaskModule do
  @moduledoc """
  Task Module
  """

  alias Scuti.Context.TaskContext
  alias Scuti.Service.ValidatorService

  @doc """
  Create a task
  """
  def create_task(data \\ %{}) do
    task =
      TaskContext.new_task(%{
        payload: Jason.encode!(data.payload),
        result: Jason.encode!(data.result),
        status: data.status,
        deployment_id: data.deployment_id,
        run_at: DateTime.utc_now()
      })

    case TaskContext.create_task(task) do
      {:ok, task} ->
        {:ok, task}

      {:error, changeset} ->
        messages =
          changeset.errors()
          |> Enum.map(fn {field, {message, _options}} -> "#{field}: #{message}" end)

        {:error, Enum.at(messages, 0)}
    end
  end

  @doc """
  Create a task log
  """
  def create_task_log(data \\ %{}) do
    task_log =
      TaskContext.new_task_log(%{
        host_id: data.host_id,
        task_id: data.task_id,
        type: data.type,
        record: data.record
      })

    case TaskContext.create_task_log(task_log) do
      {:ok, task_log} ->
        {:ok, task_log}

      {:error, changeset} ->
        messages =
          changeset.errors()
          |> Enum.map(fn {field, {message, _options}} -> "#{field}: #{message}" end)

        {:error, Enum.at(messages, 0)}
    end
  end

  @doc """
  Get task by ID
  """
  def get_task_by_id(id) do
    TaskContext.get_task_by_id(id)
  end

  @doc """
  Get task by UUID
  """
  def get_task_by_uuid(uuid) do
    TaskContext.get_task_by_uuid(uuid)
  end

  @doc """
  Update task status
  """
  def update_task_status(id, status) do
    task = get_task_by_id(id)

    case task do
      nil ->
        {:error, "Task with id #{id} not found"}

      _ ->
        TaskContext.update_task(task, %{
          status: status,
          run_at: DateTime.utc_now()
        })

        {:ok, "Task with id #{id} updated successfully"}
    end
  end

  @doc """
  Get task result
  """
  def get_task_result(id) do
    task = get_task_by_id(id)

    case task do
      nil ->
        {:error, "Task with id #{id} not found"}

      _ ->
        result =
          if task.result == nil or task.result == "" do
            %{total_hosts: 0, updated_hosts: 0, failed_hosts: 0}
          else
            Jason.decode!(task.result)
          end

        {:ok, result}
    end
  end

  @doc """
  Update task result
  """
  def update_task_result(id, result) do
    task = get_task_by_id(id)

    case task do
      nil ->
        {:error, "Task with id #{id} not found"}

      _ ->
        TaskContext.update_task(task, %{
          result: Jason.encode!(result)
        })

        {:ok, "Task with id #{id} updated successfully"}
    end
  end

  @doc """
  Delete A Task
  """
  def delete_task(id) do
    task =
      id
      |> ValidatorService.parse_int()
      |> TaskContext.get_task_by_id()

    case task do
      nil ->
        {:not_found, "Task with ID #{id} not found"}

      _ ->
        TaskContext.delete_task(task)
        {:ok, "Task with ID #{id} deleted successfully"}
    end
  end

  @doc """
  Get all Pending Tasks
  """
  def get_pending_tasks() do
    TaskContext.get_pending_tasks()
  end

  @doc """
  Count updated hosts
  """
  def count_updated_hosts(task_id) do
    TaskContext.count_updated_hosts(task_id)
  end

  @doc """
  Count failed hosts
  """
  def count_failed_hosts(task_id) do
    TaskContext.count_failed_hosts(task_id)
  end
end
