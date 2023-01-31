# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Worker.PatchTask do
  require Logger

  def run do
    Logger.info("PatchTask Process Started")

    receive do
      msg ->
        Logger.info(
          "Received patch request with id #{msg.id}, task #{msg.task.id}, deployment #{msg.deployment.id}, host #{msg.host.id}"
        )

        # --
        Logger.info("Send to remote agent #{msg.id}")
        # --
        Logger.info("Wait till the agent respond back #{msg.id}")
        # --
        Logger.info("Update the management database #{msg.id}")

        check(msg)
    end
  end

  def check(msg) do
    Logger.info("Check task status #{msg.id}")

    run_again = true

    if run_again do
      check(msg)
    end

    Process.sleep(30000)
  end
end
