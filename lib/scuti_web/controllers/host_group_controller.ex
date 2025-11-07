# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.HostGroupController do
  @moduledoc """
  HostGroup Controller
  """

  use ScutiWeb, :controller

  require Logger

  alias Scuti.Module.HostGroupModule
  alias Scuti.Module.PermissionModule
  alias Scuti.Module.TeamModule
  alias Scuti.Service.ValidatorService
  alias Scuti.Service.AuthService

  @default_list_limit 10
  @default_list_offset 0
  @name_min_length 2
  @name_max_length 60
  @description_min_length 2
  @description_max_length 250

  plug :regular_user when action in [:list, :index, :create, :update, :delete]
  plug :access_check when action in [:index, :update, :delete]

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

  defp access_check(conn, _opts) do
    Logger.info("Validate if user can access host group")

    if not PermissionModule.can_access_group_uuid(
         :group,
         conn.assigns[:user_role],
         conn.params["uuid"],
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

    {groups, count} =
      if conn.assigns[:is_super] do
        {HostGroupModule.get_groups(offset, limit), HostGroupModule.count_groups()}
      else
        {HostGroupModule.get_user_groups(conn.assigns[:user_id], offset, limit),
         HostGroupModule.count_user_groups(conn.assigns[:user_id])}
      end

    render(conn, "list.json", %{
      groups: groups,
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
          HostGroupModule.create_group(%{
            name: params["name"],
            description: params["description"],
            secret_key: AuthService.get_random_salt(),
            team_id: TeamModule.get_team_id_with_uuid(params["team_id"]),
            labels: params["labels"],
            remote_join: params["remote_join"] == "enabled"
          })

        case result do
          {:ok, group} ->
            conn
            |> put_status(:created)
            |> render("index.json", %{group: group})

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
  def index(conn, %{"uuid" => uuid}) do
    case HostGroupModule.get_group_by_uuid(uuid) do
      {:not_found, msg} ->
        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: msg})

      {:ok, group} ->
        conn
        |> put_status(:ok)
        |> render("index.json", %{group: group})
    end
  end

  @doc """
  Update Action Endpoint
  """
  def update(conn, params) do
    case validate_update_request(params, params["uuid"]) do
      {:ok, _} ->
        result =
          HostGroupModule.update_group(%{
            uuid: params["uuid"],
            name: params["name"],
            description: params["description"],
            team_id: TeamModule.get_team_id_with_uuid(params["team_id"]),
            labels: params["labels"],
            remote_join: params["remote_join"] == "enabled"
          })

        case result do
          {:ok, group} ->
            conn
            |> put_status(:ok)
            |> render("index.json", %{group: group})

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
  def delete(conn, %{"uuid" => uuid}) do
    Logger.info("Attempt to delete host group with uuid #{uuid}")

    case HostGroupModule.delete_group_by_uuid(uuid) do
      {:not_found, msg} ->
        Logger.info("Host group with uuid #{uuid} not found")

        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: msg})

      {:ok, _} ->
        Logger.info("Host group with uuid #{uuid} is deleted")

        conn
        |> send_resp(:no_content, "")
    end
  end

  defp validate_create_request(params) do
    errs = %{
      name_required: "Group name is required",
      name_invalid: "Group name is invalid",
      description_required: "Group description is required",
      description_invalid: "Group description is invalid",
      labels_required: "Group labels is required",
      labels_invalid: "Group labels is invalid",
      remote_join_required: "Group remote join is required",
      remote_join_invalid: "Group remote join is invalid",
      team_id_required: "Group team id is required",
      team_id_invalid: "Group team id is invalid"
    }

    with {:ok, _} <- ValidatorService.is_string?(params["name"], errs.name_required),
         {:ok, _} <-
           ValidatorService.is_string?(params["description"], errs.description_required),
         {:ok, _} <- ValidatorService.is_string?(params["labels"], errs.labels_required),
         {:ok, _} <-
           ValidatorService.is_string?(params["remote_join"], errs.remote_join_required),
         {:ok, _} <- ValidatorService.is_string?(params["team_id"], errs.team_id_required),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["name"],
             @name_min_length,
             @name_max_length,
             errs.name_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["description"],
             @description_min_length,
             @description_max_length,
             errs.description_invalid
           ),
         {:ok, _} <- ValidatorService.is_uuid?(params["team_id"], errs.team_id_invalid),
         {:ok, _} <- ValidatorService.is_labels?(params["labels"], errs.labels_invalid),
         {:ok, _} <-
           ValidatorService.in?(
             params["remote_join"],
             ["enabled", "disabled"],
             errs.remote_join_invalid
           ) do
      {:ok, ""}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_update_request(params, group_id) do
    errs = %{
      name_required: "Group name is required",
      name_invalid: "Group name is invalid",
      description_required: "Group description is required",
      description_invalid: "Group description is invalid",
      labels_required: "Group labels is required",
      labels_invalid: "Group labels is invalid",
      remote_join_required: "Group remote join is required",
      remote_join_invalid: "Group remote join is invalid",
      team_id_required: "Group team id is required",
      team_id_invalid: "Group team id  is invalid",
      group_id_required: "Group id is required",
      group_id_invalid: "Group id is invalid"
    }

    with {:ok, _} <- ValidatorService.is_string?(params["name"], errs.name_required),
         {:ok, _} <-
           ValidatorService.is_string?(params["description"], errs.description_required),
         {:ok, _} <- ValidatorService.is_string?(params["labels"], errs.labels_required),
         {:ok, _} <-
           ValidatorService.is_string?(params["remote_join"], errs.remote_join_required),
         {:ok, _} <- ValidatorService.is_string?(params["team_id"], errs.team_id_required),
         {:ok, _} <- ValidatorService.is_string?(group_id, errs.group_id_required),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["name"],
             @name_min_length,
             @name_max_length,
             errs.name_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["description"],
             @description_min_length,
             @description_max_length,
             errs.description_invalid
           ),
         {:ok, _} <- ValidatorService.is_uuid?(params["team_id"], errs.team_id_invalid),
         {:ok, _} <- ValidatorService.is_uuid?(group_id, errs.group_id_invalid),
         {:ok, _} <- ValidatorService.is_labels?(params["labels"], errs.labels_invalid),
         {:ok, _} <-
           ValidatorService.in?(
             params["remote_join"],
             ["enabled", "disabled"],
             errs.remote_join_invalid
           ) do
      {:ok, ""}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
