# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Worker.DeploymentWorker do
  use GenServer

  require Logger

  alias Scuti.Module.TaskModule
  alias Scuti.Module.DeploymentModule

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  ## Callbacks
  @impl true
  def init(state) do
    Logger.info("Deployment Worker Started")

    schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_info(:fire, state) do
    # Reschedule once more
    schedule_work()

    Logger.info("Deployment Worker Task Trigger")

    # once deployments
    deployments = DeploymentModule.get_pending_once_deployments()

    for deployment <- deployments do
      result =
        TaskModule.create_task(%{
          payload: %{
            patch_type: deployment.patch_type,
            pre_patch_script: deployment.pre_patch_script || "",
            patch_script: deployment.patch_script || "",
            post_patch_script: deployment.post_patch_script || "",
            post_patch_reboot_option: deployment.post_patch_reboot_option
          },
          result: %{total_hosts: 0, updated_hosts: 0, failed_hosts: 0},
          status: "pending",
          deployment_id: deployment.id
        })

      case result do
        {:ok, task} ->
          Logger.info("Task created with id #{task.id}")

          case DeploymentModule.update_deployment_status(deployment.id, "pending") do
            {:ok, msg} ->
              Logger.info(msg)

            {:error, msg} ->
              Logger.error(msg)
          end

        {:error, msg} ->
          Logger.error("Error while creating a task: #{msg}")
      end
    end

    {:noreply, state}
  end

  defp schedule_work do
    # We schedule the work to happen in 60 seconds
    Process.send_after(self(), :fire, 60 * 1000)
  end
end
