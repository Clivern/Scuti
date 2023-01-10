# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.UserController do
  @moduledoc """
  User Controller
  """

  use ScutiWeb, :controller

  require Logger

  alias Scuti.Module.UserModule
  alias Scuti.Module.SettingsModule
  alias Scuti.Service.ValidatorService
  alias Scuti.Exception.InvalidRequest
  alias Scuti.Service.AuthService
  alias Scuti.Exception.ResourceNotFound
  alias Scuti.Exception.InvalidRequest
  alias Scuti.Exception.InternalError

  @default_list_limit "10"
  @default_list_offset "0"

  plug :super_user, only: [:list, :index, :create, :update, :delete]

  defp super_user(conn, _opts) do
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
      users: UserModule.get_users(offset, limit),
      metadata: %{
        limit: limit,
        offset: offset,
        totalCount: UserModule.count_users()
      }
    })
  end

  @doc """
  Index Action Endpoint
  """
  def index(conn, %{"id" => id}) do
    Logger.info("Get user with id #{id}. RequestId=#{conn.assigns[:request_id]}")

    try do
      if not ValidatorService.validate_int(id) do
        raise InvalidRequest, message: "Invalid Request"
      end

      id = ValidatorService.get_int(id, 0)
      result = UserModule.get_user_by_id(id)

      case result do
        {:not_found, _} ->
          raise ResourceNotFound, "User with id #{id} not found"

        {:ok, user} ->
          conn
          |> put_status(:ok)
          |> render("index.json", %{user: user})
      end
    rescue
      e in InvalidRequest ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", %{message: e.message})

      e in ResourceNotFound ->
        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: e.message})

      _ ->
        conn
        |> put_status(:internal_server_error)
        |> render("error.json", %{message: "Internal server error"})
    end
  end

  @doc """
  Create Action Endpoint
  """
  def create(conn, params) do
    try do
      validate_create_request(params)

      email = ValidatorService.get_str(params["email"], "")
      name = ValidatorService.get_str(params["name"], "")
      role = ValidatorService.get_str(params["role"], "")
      password = ValidatorService.get_str(params["password"], "")
      api_key = AuthService.get_random_salt()
      app_key = SettingsModule.get_config("app_key", "")

      result =
        UserModule.create_user(%{
          name: name,
          email: email,
          api_key: api_key,
          role: role,
          password: password,
          app_key: app_key
        })

      case result do
        {:error, _} ->
          raise InvalidRequest, message: "Invalid Request"

        {:ok, user} ->
          conn
          |> put_status(:created)
          |> render("create.json", %{user: user})
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
    Logger.info("Delete user with id #{id}. RequestId=#{conn.assigns[:request_id]}")

    try do
      if not ValidatorService.validate_int(id) do
        raise InvalidRequest, message: "Invalid Request"
      end

      id = ValidatorService.get_int(id, 0)

      result = UserModule.delete_user(id)

      case result do
        {:not_found, _} ->
          raise ResourceNotFound, "User with id #{id} not found"

        {:error, _} ->
          raise InternalError, message: "Internal Server Error"

        {:ok, _} ->
          conn
          |> send_resp(:no_content, "")
      end
    rescue
      e in InvalidRequest ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", %{message: e.message})

      e in ResourceNotFound ->
        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: e.message})

      _ ->
        conn
        |> put_status(:internal_server_error)
        |> render("error.json", %{message: "Internal server error"})
    end
  end

  defp validate_create_request(params) do
    email = ValidatorService.get_str(params["email"], "")
    name = ValidatorService.get_str(params["name"], "")
    role = ValidatorService.get_str(params["role"], "regular")
    password = ValidatorService.get_str(params["password"], "")

    if ValidatorService.is_empty(email) do
      raise InvalidRequest, message: "User email is required"
    end

    if ValidatorService.is_empty(name) do
      raise InvalidRequest, message: "User name is required"
    end

    if ValidatorService.is_empty(role) do
      raise InvalidRequest, message: "User role is required"
    end

    if ValidatorService.is_empty(password) do
      raise InvalidRequest, message: "User password is required"
    end
  end
end
