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
  alias Scuti.Service.ValidatorService
  alias Scuti.Service.AuthService
  alias Scuti.Exception.InvalidRequest

  @default_list_limit "10"
  @default_list_offset "0"

  plug :regular_user, only: [:list, :index, :create, :update, :delete]

  defp regular_user(conn, _opts) do
    Logger.info("Validate user permissions. RequestId=#{conn.assigns[:request_id]}")

    if not conn.assigns[:is_logged] do
      Logger.info(
        "User doesn't have the right access permissions. RequestId=#{conn.assigns[:request_id]}"
      )

      conn
      |> put_status(:forbidden)
      |> render("error.json", %{message: "Forbidden Access"})
    else
      Logger.info("User has the right access permissions. RequestId=#{conn.assigns[:request_id]}")

      conn
    end
  end

  @doc """
  List Action Endpoint
  """
  def list(conn, params) do
    limit = ValidatorService.get_int(params["limit"], @default_list_limit)
    offset = ValidatorService.get_int(params["offset"], @default_list_offset)
    user_teams = HostGroupModule.get_user_teams(conn.assigns[:user_id])

    teams_ids = []

    teams_ids =
      for user_team <- user_teams do
        teams_ids ++ user_team.id
      end

    render(conn, "list.json", %{
      groups: HostGroupModule.get_groups_by_teams(teams_ids, offset, limit),
      metadata: %{
        limit: limit,
        offset: offset,
        totalCount: HostGroupModule.count_groups_by_teams(teams_ids)
      }
    })
  end

  @doc """
  Create Action Endpoint
  """
  def create(conn, params) do
    try do
      validate_create_request(params)

      name = ValidatorService.get_str(params["name"], "")
      labels = ValidatorService.get_str(params["labels"], "")
      remote_join = ValidatorService.get_list(params["remoteJoin"], "disabled")
      team = ValidatorService.get_int(params["teamId"], 0)

      result =
        HostGroupModule.create_group(%{
          name: name,
          secret_key: AuthService.get_random_salt(),
          team_id: team,
          labels: labels,
          remote_join: remote_join == "enabled"
        })

      case result do
        {:error, _} ->
          raise InvalidRequest, message: "Invalid Request"

        {:ok, group} ->
          conn
          |> put_status(:created)
          |> render("create.json", %{group: group})
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
  Index Action Endpoint
  """
  def index(conn, _params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok"}))
  end

  @doc """
  Update Action Endpoint
  """
  def update(conn, _params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok"}))
  end

  @doc """
  Delete Action Endpoint
  """
  def delete(conn, _params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok"}))
  end

  defp validate_create_request(params) do
    name = ValidatorService.get_str(params["name"], "")
    remote_join = ValidatorService.get_str(params["remoteJoin"], "disabled")

    if ValidatorService.is_empty(name) do
      raise InvalidRequest, message: "Host group name is required"
    end

    if ValidatorService.is_empty(remote_join) do
      raise InvalidRequest, message: "Remote join option is required"
    end

    if not ValidatorService.validate_int(params["teamId"]) do
      raise InvalidRequest, message: "Team is required"
    end

    team = ValidatorService.get_int(params["teamId"], 0)

    if not HostGroupModule.validate_team_id(team) do
      raise InvalidRequest, message: "Team is required"
    end
  end
end
