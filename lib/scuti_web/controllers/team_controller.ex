# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.TeamController do
  @moduledoc """
  Team Controller
  """

  use ScutiWeb, :controller

  alias Scuti.Module.TeamModule
  alias Scuti.Module.UserModule
  alias Scuti.Service.ValidatorService
  alias Scuti.Exception.InvalidRequest

  require Logger

  @default_list_limit "10"
  @default_list_offset "0"

  plug :only_super_users, only: [:list, :index, :create, :update, :delete]

  defp only_super_users(conn, _opts) do
    Logger.info("Validate user permissions. RequestId=#{conn.assigns[:request_id]}")

    if not conn.assigns[:is_super] do
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

    render(conn, "list.json", %{
      users: TeamModule.get_teams(offset, limit),
      metadata: %{
        limit: limit,
        offset: offset,
        totalCount: TeamModule.count_teams()
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
      description = ValidatorService.get_str(params["description"], "")
      members = ValidatorService.get_list(params["members"], [])

      result =
        TeamModule.create_team(%{
          name: name,
          description: description
        })

      TeamModule.sync_team_members(members)

      case result do
        {:error, _} ->
          raise InvalidRequest, message: "Invalid Request"

        {:ok, team} ->
          conn
          |> put_status(:created)
          |> render("create.json", %{team: team})
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
  def delete(conn, %{"id" => id}) do
    Logger.info("Delete team with id #{id}. RequestId=#{conn.assigns[:request_id]}")

    result = TeamModule.delete_team(id)

    case result do
      {:not_found, msg} ->
        conn
        |> put_status(:not_found)
        |> render("error.json", %{error: msg})

      {:ok, _} ->
        conn
        |> send_resp(:no_content, "")

      {:error, msg} ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", %{error: msg})
    end
  end

  defp validate_create_request(params) do
    name = ValidatorService.get_str(params["name"], "")
    description = ValidatorService.get_str(params["description"], "")
    members = ValidatorService.get_list(params["members"], [])

    if ValidatorService.is_empty(name) do
      raise InvalidRequest, message: "Team name is required"
    end

    if ValidatorService.is_empty(description) do
      raise InvalidRequest, message: "Team description is required"
    end

    for member <- members do
      if not ValidatorService.validate_int(member) do
        raise InvalidRequest, message: "Team members are invalid"
      end

      if UserModule.validate_user_id(member) do
        raise InvalidRequest, message: "Team members are invalid"
      end
    end
  end
end
