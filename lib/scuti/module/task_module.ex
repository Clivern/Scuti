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
  Delete A Task
  """
  def delete_task(id) do
    case ValidatorService.validate_int(id) do
      true ->
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

      false ->
        {:error, "Invalid Task ID"}
    end
  end
end
