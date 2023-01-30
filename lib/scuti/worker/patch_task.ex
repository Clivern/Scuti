# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Worker.PatchTask do
  require Logger

  def run do
    Logger.info("PatchTask Process Started")

    receive do
      msg ->
        Logger.info("Received #{inspect(msg)}")
        # --
        Logger.info("Send to remote agent #{inspect(msg)}")
        # --
        Logger.info("Wait till the agent respond back #{inspect(msg)}")
        # --
        Logger.info("Update the management database #{inspect(msg)}")

        check(msg)
    end
  end

  def check(msg) do
    Logger.info("Check task status #{inspect(msg)}")

    run_again = true

    if run_again do
      check(msg)
    end

    Process.sleep(30000)
  end
end
