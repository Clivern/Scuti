# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.HostController do
  @moduledoc """
  Host Controller
  """

  use ScutiWeb, :controller

  require Logger

  alias Scuti.Module.HostGroupModule
  alias Scuti.Module.HostModule
  alias Scuti.Module.PermissionModule
  alias Scuti.Service.ValidatorService
  alias Scuti.Service.AuthService

  @default_list_limit 10
  @default_list_offset 0
  @name_min_length 2
  @name_max_length 60
  @hostname_min_length 2
  @hostname_max_length 60
  @agent_address_min_length 2
  @agent_address_max_length 60
  @secret_key_min_length 2
  @secret_key_max_length 60

  plug :regular_user when action in [:list, :index, :create, :update, :delete]
  plug :host_access_check when action in [:index, :update, :delete]
  plug :group_access_check when action in [:list, :index, :create, :update, :delete]

  defp regular_user(conn, _opts) do
    Logger.info("Validate user permissions")

    if not conn.assigns[:is_logged] do
      Logger.info("User doesn't have the right access permissions")

      conn
      |> put_status(:forbidden)
      |> render("error.json", %{message: "Forbidden Access"})
    else
      Logger.info("User has the right access permissions")

      conn
    end
  end

  defp host_access_check(conn, _opts) do
    Logger.info("Validate if user can access host")

    if not PermissionModule.can_access_host_uuid(
         :host,
         conn.assigns[:user_role],
         conn.params["host_uuid"],
         conn.assigns[:user_id]
       ) do
      Logger.info("User doesn't own the host")

      conn
      |> put_status(:forbidden)
      |> render("error.json", %{message: "Forbidden Access"})
      |> halt
    else
      Logger.info("User can access the host")

      conn
    end
  end

  defp group_access_check(conn, _opts) do
    Logger.info("Validate if user can access host group")

    if not PermissionModule.can_access_group_uuid(
         :group,
         conn.assigns[:user_role],
         conn.params["group_uuid"],
         conn.assigns[:user_id]
       ) do
      Logger.info("User doesn't own the host group")

      conn
      |> put_status(:forbidden)
      |> render("error.json", %{message: "Forbidden Access"})
      |> halt
    else
      Logger.info("User can access the host group")

      conn
    end
  end

  @doc """
  List Action Endpoint
  """
  def list(conn, params) do
    limit = params["limit"] || @default_list_limit
    offset = params["offset"] || @default_list_offset
    group_uuid = params["group_uuid"] || ""

    hosts = HostModule.get_hosts(group_uuid, offset, limit)
    count = HostModule.count_hosts(group_uuid)

    render(conn, "list.json", %{
      hosts: hosts,
      metadata: %{
        limit: limit,
        offset: offset,
        totalCount: count
      }
    })
  end

  @doc """
  Create Action Endpoint
  """
  def create(conn, params) do
    case validate_create_request(params) do
      {:ok, _} ->
        result =
          HostModule.create_host(%{
            name: params["name"],
            hostname: params["hostname"],
            agent_address: params["agent_address"],
            labels: params["labels"],
            host_group_id: HostGroupModule.get_group_id_with_uuid(params["group_uuid"]),
            secret_key:
              if params["secret_key"] == "" do
                AuthService.get_uuid()
              else
                params["secret_key"]
              end
          })

        case result do
          {:ok, host} ->
            conn
            |> put_status(:created)
            |> render("index.json", %{host: host})

          {:error, msg} ->
            conn
            |> put_status(:bad_request)
            |> render("error.json", %{message: msg})
        end

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", %{message: reason})
    end
  end

  @doc """
  Index Action Endpoint
  """
  def index(conn, %{"host_uuid" => uuid}) do
    case HostModule.get_host_by_uuid(uuid) do
      {:not_found, msg} ->
        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: msg})

      {:ok, host} ->
        conn
        |> put_status(:ok)
        |> render("index.json", %{host: host})
    end
  end

  @doc """
  Update Action Endpoint
  """
  def update(conn, params) do
    case validate_update_request(params, params["host_uuid"]) do
      {:ok, _} ->
        result =
          HostModule.update_host(%{
            uuid: params["host_uuid"],
            name: params["name"],
            hostname: params["hostname"],
            agent_address: params["agent_address"],
            labels: params["labels"],
            secret_key: params["secret_key"]
          })

        case result do
          {:ok, host} ->
            conn
            |> put_status(:ok)
            |> render("index.json", %{host: host})

          {:error, msg} ->
            conn
            |> put_status(:bad_request)
            |> render("error.json", %{message: msg})
        end

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", %{message: reason})
    end
  end

  @doc """
  Delete Action Endpoint
  """
  def delete(conn, %{"host_uuid" => uuid}) do
    Logger.info("Attempt to delete host with uuid #{uuid}")

    case HostModule.delete_host_by_uuid(uuid) do
      {:not_found, msg} ->
        Logger.info("Host with uuid #{uuid} not found")

        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: msg})

      {:ok, _} ->
        Logger.info("Host with uuid #{uuid} is deleted")

        conn
        |> send_resp(:no_content, "")
    end
  end

  defp validate_create_request(params) do
    errs = %{
      name_required: "Host name is required",
      name_invalid: "Host name is invalid",
      hostname_required: "Host hostname is required",
      hostname_invalid: "Host hostname is invalid",
      agent_address_required: "Host agent address is required",
      agent_address_invalid: "Host agent address is invalid",
      labels_required: "Host labels are required",
      labels_invalid: "Host labels are invalid",
      host_group_id_required: "Host group ID is required",
      host_group_id_invalid: "Host group ID is invalid",
      secret_key_required: "Host secret key is required",
      secret_key_invalid: "Host secret key is invalid"
    }

    with {:ok, _} <- ValidatorService.is_string?(params["name"], errs.name_required),
         {:ok, _} <- ValidatorService.is_string?(params["hostname"], errs.hostname_required),
         {:ok, _} <-
           ValidatorService.is_string?(params["agent_address"], errs.agent_address_required),
         {:ok, _} <- ValidatorService.is_string?(params["labels"], errs.labels_required),
         {:ok, _} <-
           ValidatorService.is_string?(params["group_uuid"], errs.host_group_id_required),
         {:ok, _} <- ValidatorService.is_string?(params["secret_key"], errs.secret_key_required),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["name"],
             @name_min_length,
             @name_max_length,
             errs.name_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["hostname"],
             @hostname_min_length,
             @hostname_max_length,
             errs.hostname_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["agent_address"],
             @agent_address_min_length,
             @agent_address_max_length,
             errs.agent_address_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["secret_key"],
             @secret_key_min_length,
             @secret_key_max_length,
             errs.secret_key_invalid
           ),
         {:ok, _} <- ValidatorService.is_labels?(params["labels"], errs.labels_invalid),
         {:ok, _} <-
           ValidatorService.is_uuid?(params["group_uuid"], errs.host_group_id_invalid) do
      {:ok, ""}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_update_request(params, host_id) do
    errs = %{
      name_required: "Host name is required",
      name_invalid: "Host name is invalid",
      hostname_required: "Host hostname is required",
      hostname_invalid: "Host hostname is invalid",
      agent_address_required: "Host agent address is required",
      agent_address_invalid: "Host agent address is invalid",
      labels_required: "Host labels are required",
      labels_invalid: "Host labels are invalid",
      secret_key_required: "Host secret key is required",
      secret_key_invalid: "Host secret key is invalid",
      host_id_required: "Host ID is required",
      host_id_invalid: "Host ID is invalid"
    }

    with {:ok, _} <- ValidatorService.is_string?(params["name"], errs.name_required),
         {:ok, _} <- ValidatorService.is_string?(params["hostname"], errs.hostname_required),
         {:ok, _} <-
           ValidatorService.is_string?(params["agent_address"], errs.agent_address_required),
         {:ok, _} <- ValidatorService.is_string?(params["labels"], errs.labels_required),
         {:ok, _} <- ValidatorService.is_string?(params["secret_key"], errs.secret_key_required),
         {:ok, _} <- ValidatorService.is_string?(host_id, errs.host_id_required),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["name"],
             @name_min_length,
             @name_max_length,
             errs.name_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["hostname"],
             @hostname_min_length,
             @hostname_max_length,
             errs.hostname_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["agent_address"],
             @agent_address_min_length,
             @agent_address_max_length,
             errs.agent_address_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["secret_key"],
             @secret_key_min_length,
             @secret_key_max_length,
             errs.secret_key_invalid
           ),
         {:ok, _} <- ValidatorService.is_labels?(params["labels"], errs.labels_invalid),
         {:ok, _} <- ValidatorService.is_uuid?(host_id, errs.host_id_invalid) do
      {:ok, ""}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
