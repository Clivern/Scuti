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
    Logger.info("Task Worker Started 🔥")

    schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_info(:fire, state) do
    Logger.info("Task Worker Job Trigger 🔥")

    tasks = TaskModule.get_pending_tasks()

    pids =
      for task <- tasks do
        deployment = DeploymentModule.get_deployment_by_id(task.deployment_id)

        pid = case deployment do
          nil ->
            # Delete Task
            TaskModule.delete_task(task.id)

          _ ->
            pid = if deployment.rollout_strategy == "one_by_one" do
              pid = spawn(fn -> Scuti.Worker.OneByOneStrategy.handle(task, deployment) end)
              pid
            end

            pid
        end
        pid
      end

    # Block the process till all pids finish
    for pid <- pids do
      Scuti.Worker.WaitForProcess.is_alive?(pid)
    end

    # Reschedule once more
    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    # We schedule the work to happen in 60 seconds
    Process.send_after(self(), :fire, 60 * 1000)
  end
end
