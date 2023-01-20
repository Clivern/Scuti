# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Worker.HostWorker do
  use GenServer

  require Logger

  alias Scuti.Module.HostModule

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  ## Callbacks
  @impl true
  def init(state) do
    Logger.info("Host Worker Started 🔥")

    schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_info(:fire, state) do
    # Reschedule once more
    schedule_work()

    Logger.info("Host Worker Task Trigger 🔥")

    Logger.info("Mark absent hosts for 2 minutes as DOWN 🔥")

    count = HostModule.mark_hosts_down(120)

    Logger.info("Mark #{count} hosts as DOWN 🔥")

    {:noreply, state}
  end

  defp schedule_work do
    # We schedule the work to happen in 60 seconds
    Process.send_after(self(), :fire, 60 * 1000)
  end
end
