# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Worker.WaitForProcess do
  require Logger

  @doc """
  Check is pid is alive
  """
  def is_alive?(pid) do
    if alive?(pid) do
      Logger.info("Process is alive #{inspect(pid)}")
      Process.sleep(60000)
      is_alive?(pid)
    else
      Logger.info("Process is not alive anymore #{inspect(pid)}")
    end
  end

  @doc """
  Check is pid is alive
  """
  def alive?(pid) do
    pid |> Process.alive?()
  end
end
