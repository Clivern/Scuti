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
end
