# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.AgentController do
  @moduledoc """
  Agent Controller
  """

  use ScutiWeb, :controller

  @doc """
  Join Action Endpoint

  {
    group_uuid: ..
    group_secret: ..
    name: ..
    hostname: ..
    agent_address: ..
    labels: ..
    secret_key: ..
  }
  """
  def join(conn, _params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok"}))
  end

  @doc """
  Heartbeat Action Endpoint

  encrypt(encode({
    group_uuid: ..
    group_secret: ...
    status: up
  }), agent_secret)
  """
  def heartbeat(conn, _params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok"}))
  end

  @doc """
  Report Action Endpoint

  encrypt(encode({
    group_uuid: ..
    group_secret: ..
    event: Agent will reboot the host
  }), agent_secret)
  """
  def report(conn, _params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok"}))
  end
end
