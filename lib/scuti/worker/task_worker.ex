# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Worker.TaskWorker do
  use GenServer

  require Logger

  alias Scuti.Module.DeploymentModule
  alias Scuti.Module.TaskModule

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  ## Callbacks
  @impl true
  def init(state) do
    Logger.info("Task Worker Started")

    schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_info(:fire, state) do
    Logger.info("Task Worker Job Trigger")

    # Reschedule once more
    schedule_work()

    # Fetch pending tasks
    tasks = TaskModule.get_pending_tasks()

    for task <- tasks do
      deployment = DeploymentModule.get_deployment_by_id(task.deployment_id)

      case deployment do
        nil ->
          # Delete Task
          Logger.info("Delete task with id #{task.id} since deployment is missing")
          TaskModule.delete_task(task.id)

        _ ->
          Logger.info("Mark task with id #{task.id} as running")
          TaskModule.update_task_status(task.id, "running")

          if deployment.rollout_strategy == "one_by_one" do
            pid = spawn(fn -> Scuti.Worker.OneByOneStrategy.handle(task, deployment) end)
            Logger.info("Spawn a new process #{inspect(pid)}")
          end
      end
    end

    {:noreply, state}
  end

  defp schedule_work do
    # We schedule the work to happen in 60 seconds
    Process.send_after(self(), :fire, 60 * 1000)
  end
end
