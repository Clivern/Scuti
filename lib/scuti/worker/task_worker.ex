# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Worker.TaskWorker do
  use GenServer

  require Logger

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
    # Reschedule once more
    schedule_work()

    Logger.info("Task Worker Job Trigger 🔥")

    IO.inspect(state)

    {:noreply, state}
  end

  defp schedule_work do
    # We schedule the work to happen in 60 seconds
    Process.send_after(self(), :fire, 60 * 1000)
  end
end
