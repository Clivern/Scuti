# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Worker.OneByOneStrategy do
  alias Scuti.Module.DeploymentModule

  def handle(task, deployment) do
    # Get Target hosts
    hosts = DeploymentModule.get_deployment_target_hosts(deployment.id)

    for host <- hosts do
      # Spawn a patch job process
      pid = spawn(Scuti.Worker.PatchTask, :run, [])

      send(pid, %{
        id: Ecto.UUID.generate(),
        deployment: deployment,
        host: host
      })

      # Block the process till the task finishes
      Scuti.Worker.WaitForProcess.is_alive?(pid)
    end
  end
end
