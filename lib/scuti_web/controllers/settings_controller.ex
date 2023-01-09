# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.SettingsController do
  @moduledoc """
  Settings Controller
  """

  use ScutiWeb, :controller

  alias Scuti.Module.SettingsModule
  alias Scuti.Service.ValidatorService

  require Logger

  plug :only_super_users, only: [:update]

  defp only_super_users(conn, _opts) do
    Logger.info("Validate user permissions. RequestId=#{conn.assigns[:request_id]}")

    # If user not authenticated, return forbidden access
    if conn.assigns[:is_logged] == false do
      Logger.info("User is not authenticated. RequestId=#{conn.assigns[:request_id]}")

      conn
      |> put_status(:forbidden)
      |> render("error.json", %{message: "Forbidden Access"})
      |> halt()
    else
      # If user not super, return forbidden access
      if conn.assigns[:user_role] != :super do
        Logger.info(
          "User doesn't have a super permission. RequestId=#{conn.assigns[:request_id]}"
        )

        conn
        |> put_status(:forbidden)
        |> render("error.json", %{message: "Forbidden Access"})
        |> halt()
      else
        Logger.info(
          "User with id #{conn.assigns[:user_id]} can access this endpoint. RequestId=#{conn.assigns[:request_id]}"
        )
      end
    end

    conn
  end

  @doc """
  Update Action Endpoint
  """
  def update(conn, params) do
    config_results =
      SettingsModule.update_configs(%{
        app_name: ValidatorService.get_str(params["app_name"], ""),
        app_url: ValidatorService.get_str(params["app_url"], ""),
        app_email: ValidatorService.get_str(params["app_email"], "")
      })

    for config_result <- config_results do
      case config_result do
        {:error, msg} ->
          conn
          |> put_status(:bad_request)
          |> render("error.json", %{message: msg})
          |> halt()

        _ ->
          nil
      end
    end

    conn
    |> put_status(:ok)
    |> render("success.json", %{message: "Settings updated successfully"})
  end
end
