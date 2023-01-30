# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Worker.OneByOneStrategy do
  require Logger

  alias Scuti.Module.DeploymentModule
  alias Scuti.Module.TaskModule

  def handle(task, deployment) do
    # Get Target hosts
    hosts = DeploymentModule.get_deployment_target_hosts(deployment.id)

    for host <- hosts do
      # Spawn a patch job process
      pid = spawn(Scuti.Worker.PatchTask, :run, [])

      send(pid, %{
        id: Ecto.UUID.generate(),
        deployment: deployment,
        host: host,
        task: task
      })

      # Block the process till the task finishes
      Scuti.Worker.WaitForProcess.is_alive?(pid)
    end

    # If there is no target hosts
    if length(hosts) == 0 do
      Logger.info("Mark task with id #{task.id} as skipped")
      TaskModule.update_task_status(task.id, "skipped")
    end
  end
end
