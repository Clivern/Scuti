# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.AgentController do
  @moduledoc """
  Agent Controller
  """
  use ScutiWeb, :controller

  require Logger

  @doc """
  Join Action Endpoint
  """
  def join(_conn, _params) do
  end

  @doc """
  Heartbeat Action Endpoint
  """
  def heartbeat(_conn, _params) do
  end

  @doc """
  Report Action Endpoint

  encrypt(encode({
    type: ...
    record: ....
  }), agent_secret)
  """
  def report(_conn, _params) do
  end
end
