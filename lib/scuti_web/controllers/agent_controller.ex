# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.AgentController do
  @moduledoc """
  Agent Controller
  """

  use ScutiWeb, :controller

  require Logger

  alias Scuti.Service.ValidatorService
  alias Scuti.Service.EncryptService
  alias Scuti.Module.HostGroupModule
  alias Scuti.Module.HostModule
  alias Scuti.Exception.InvalidRequest

  @doc """
  Join Action Endpoint
  """
  def join(conn, params) do
    {_, x_webhook_token} =
      Enum.find(conn.req_headers, fn {key, _value} ->
        String.downcase(key) == "x-webhook-token"
      end) ||
        {nil, ""}

    group_uuid = ValidatorService.get_str(params["group_uuid"], "")
    host_uuid = ValidatorService.get_str(params["host_uuid"], "")

    payload = %{
      name: ValidatorService.get_str(params["name"], ""),
      hostname: ValidatorService.get_str(params["hostname"], ""),
      agent_address: ValidatorService.get_str(params["agent_address"], ""),
      labels: ValidatorService.get_str(params["labels"], ""),
      agent_secret: ValidatorService.get_str(params["agent_secret"], "")
    }

    try do
      host_group = HostGroupModule.get_group_by_uuid(group_uuid)

      case host_group do
        nil ->
          raise InvalidRequest, "Invalid Request"

        _ ->
          nil
      end

      webhook_token = EncryptService.base64(host_group.secret_key, encode(payload))

      IO.puts(webhook_token)

      if webhook_token != x_webhook_token do
        raise InvalidRequest, "Invalid Request"
      end

      host = HostModule.get_host_by_uuid(host_uuid)

      case host do
        nil ->
          host =
            HostModule.create_host(%{
              uuid: host_uuid,
              name: payload[:name],
              hostname: payload[:hostname],
              host_group_id: host_group.id,
              labels: payload[:labels],
              agent_address: payload[:agent_address],
              status: "unknown",
              reported_at: DateTime.utc_now(),
              secret_key: payload[:agent_secret]
            })

          conn
          |> put_status(:ok)
          |> render("success.json", %{message: "Agent registered successfully!"})

        _ ->
          nil
      end

      if host.host_group_id != host_group.id do
        raise InvalidRequest, "Host UUID exists but belong to different host group"
      else
        raise InvalidRequest, "Host is already registered"
      end
    rescue
      e in InvalidRequest ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", %{message: e.message})

      _ ->
        conn
        |> put_status(:internal_server_error)
        |> render("error.json", %{message: "Internal server error"})
    end
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

  defp encode(%{
         name: name,
         hostname: hostname,
         agent_address: agent_address,
         labels: labels,
         agent_secret: agent_secret
       }) do
    "{'name':'#{name}','hostname':'#{hostname}','agent_address':'#{agent_address}','labels':'#{labels}','agent_secret':'#{agent_secret}'}"
  end

  defp encode(%{status: status}) do
    "{'status':'#{status}'}"
  end

  defp encode(%{event: event}) do
    "{'event':'#{event}'}"
  end
end
