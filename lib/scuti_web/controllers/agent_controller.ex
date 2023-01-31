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
  alias Scuti.Module.TaskModule
  alias Scuti.Module.HostModule
  alias Scuti.Exception.InvalidRequest
  alias Scuti.Exception.InternalError

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

      if webhook_token != x_webhook_token do
        raise InvalidRequest, "Invalid Request"
      end

      host = HostModule.get_host_by_uuid(host_uuid)

      case host do
        nil ->
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
          if host.host_group_id != host_group.id do
            raise InvalidRequest, "Host UUID exists but belong to different host group"
          else
            raise InvalidRequest, "Host is already registered"
          end
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
  """
  def heartbeat(conn, params) do
    {_, x_webhook_token} =
      Enum.find(conn.req_headers, fn {key, _value} ->
        String.downcase(key) == "x-webhook-token"
      end) ||
        {nil, ""}

    group_uuid = ValidatorService.get_str(params["group_uuid"], "")
    host_uuid = ValidatorService.get_str(params["host_uuid"], "")

    payload = %{
      status: ValidatorService.get_str(params["status"], "")
    }

    try do
      host = HostModule.get_host_by_uuid(host_uuid)
      host_group = HostGroupModule.get_group_by_uuid(group_uuid)

      if host == nil do
        raise InvalidRequest, "Invalid Request"
      end

      if host_group == nil do
        raise InvalidRequest, "Invalid Request"
      end

      webhook_token = EncryptService.base64(host.secret_key, encode(payload))

      if webhook_token != x_webhook_token do
        raise InvalidRequest, "Invalid Request"
      end

      result = HostModule.mark_host_as_up(host.id)

      case result do
        {:not_found, msg} ->
          Logger.info(msg)
          raise InvalidRequest, "Host is not found"

        {:error, msg} ->
          Logger.info(msg)
          raise InternalError, "Something goes wrong while updating the host"

        {:ok, _} ->
          conn
          |> put_status(:ok)
          |> render("success.json", %{message: "Agent reported successfully!"})
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
  Report Action Endpoint

  encrypt(encode({
    type: ...
    record: ....
  }), agent_secret)
  """
  def report(conn, params) do
    {_, x_webhook_token} =
      Enum.find(conn.req_headers, fn {key, _value} ->
        String.downcase(key) == "x-webhook-token"
      end) ||
        {nil, ""}

    group_uuid = ValidatorService.get_str(params["group_uuid"], "")
    host_uuid = ValidatorService.get_str(params["host_uuid"], "")
    task_uuid = ValidatorService.get_str(params["task_uuid"], "")

    payload = %{
      type: ValidatorService.get_str(params["type"], ""),
      record: ValidatorService.get_str(params["record"], "")
    }

    try do
      host = HostModule.get_host_by_uuid(host_uuid)
      host_group = HostGroupModule.get_group_by_uuid(group_uuid)
      task = TaskModule.get_task_by_uuid(task_uuid)

      if host == nil do
        raise InvalidRequest, "Invalid Request"
      end

      if host_group == nil do
        raise InvalidRequest, "Invalid Request"
      end

      if task == nil do
        raise InvalidRequest, "Invalid Request"
      end

      webhook_token = EncryptService.base64(host.secret_key, encode(payload))

      if webhook_token != x_webhook_token do
        raise InvalidRequest, "Invalid Request"
      end

      result =
        TaskModule.create_task_log(%{
          host_id: host.id,
          task_id: task.id,
          type: payload.type,
          record: payload.record
        })

      case result do
        {:error, msg} ->
          Logger.error(msg)
          raise InternalError, "Something goes wrong while creating the record"

        {:ok, _} ->
          # Update Task Result
          case TaskModule.get_task_result(task.id) do
            {:error, msg} ->
              Logger.error(msg)
              raise InternalError, "Something goes wrong while updating task result"

            {:ok, result} ->
              Logger.info("Updating task result")

              TaskModule.update_task_result(task.id, %{
                total_hosts: result["total_hosts"],
                updated_hosts: TaskModule.count_updated_hosts(task.id),
                failed_hosts: TaskModule.count_failed_hosts(task.id)
              })

              conn
              |> put_status(:ok)
              |> render("success.json", %{message: "Record created successfully!"})
          end
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

  defp encode(%{
         name: name,
         hostname: hostname,
         agent_address: agent_address,
         labels: labels,
         agent_secret: agent_secret
       }) do
    ~c"{\"name\":\"#{name}\",\"hostname\":\"#{hostname}\",\"agent_address\":\"#{agent_address}\",\"labels\":\"#{labels}\",\"agent_secret\":\"#{agent_secret}\"}"
  end

  defp encode(%{status: status}) do
    ~c"{\"status\":\"#{status}\"}"
  end

  defp encode(%{type: type, record: record}) do
    ~c"{\"type\":\"#{type}\",\"record\":\"#{record}\"}"
  end
end
