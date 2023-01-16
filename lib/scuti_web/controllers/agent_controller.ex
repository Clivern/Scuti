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

  encrypt(encode({
    name: ..
    hostname: ..
    agent_address: ..
    labels: ..
    agent_secret: ..
  }), group_secret)
  """
  def join(conn, %{group_uuid: group_uuid, host_uuid: host_uuid}) do
    IO.puts(group_uuid)
    IO.puts(host_uuid)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok"}))
  end

  @doc """
  Validate Action Endpoint

  encrypt(encode({
    msg: random message
  }), agent_secret)
  """
  def pong(conn, %{group_uuid: group_uuid, host_uuid: host_uuid}) do
    IO.puts(group_uuid)
    IO.puts(host_uuid)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok"}))
  end

  @doc """
  Heartbeat Action Endpoint

  encrypt(encode({
    status: up
  }), agent_secret)
  """
  def heartbeat(conn, %{group_uuid: group_uuid, host_uuid: host_uuid}) do
    IO.puts(group_uuid)
    IO.puts(host_uuid)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok"}))
  end

  @doc """
  Report Action Endpoint

  encrypt(encode({
    event: Agent will reboot the host
  }), agent_secret)
  """
  def report(conn, %{group_uuid: group_uuid, host_uuid: host_uuid}) do
    IO.puts(group_uuid)
    IO.puts(host_uuid)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok"}))
  end
end
