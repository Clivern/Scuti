# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.HostGroupController do
  @moduledoc """
  HostGroup Controller
  """

  use ScutiWeb, :controller

  # alias Scuti.Module.HostGroupModule
  # alias Scuti.Service.ValidatorService

  require Logger

  # @default_list_limit "10"
  # @default_list_offset "0"

  plug :any_user, only: [:list, :index, :create, :update, :delete]

  defp any_user(conn, _opts) do
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
  def list(conn, _params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok"}))
  end

  @doc """
  Create Action Endpoint
  """
  def create(conn, _params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok"}))
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
end
