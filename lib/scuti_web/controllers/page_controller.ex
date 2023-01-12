# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.PageController do
  @moduledoc """
  Page Controller
  """
  use ScutiWeb, :controller

  alias Scuti.Module.TeamModule
  alias Scuti.Module.UserModule
  alias Scuti.Module.SettingsModule
  alias Scuti.Module.InstallModule
  alias Scuti.Service.AuthService

  @doc """
  Login Page
  """
  def login(conn, _params) do
    is_installed = InstallModule.is_installed()

    case {is_installed, conn.assigns[:is_logged]} do
      {false, _} ->
        conn
        |> redirect(to: "/install")

      {_, true} ->
        conn
        |> redirect(to: "/")

      {true, _} ->
        conn
        |> render("login.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super]
          }
        )
    end
  end

  @doc """
  Logout Action
  """
  def logout(conn, _params) do
    AuthService.logout(conn.assigns[:user_id])

    conn
    |> clear_session()
    |> redirect(to: "/")
  end

  @doc """
  Install Page
  """
  def install(conn, _params) do
    is_installed = InstallModule.is_installed()

    case is_installed do
      true ->
        conn
        |> redirect(to: "/")

      false ->
        conn
        |> render("install.html")
    end
  end

  @doc """
  Home Page
  """
  def home(conn, _params) do
    is_installed = InstallModule.is_installed()

    case is_installed do
      false ->
        conn
        |> redirect(to: "/")

      true ->
        conn
        |> render("home.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super]
          }
        )
    end
  end

  @doc """
  Host Groups List Page
  """
  def list_groups(conn, _params) do
    case conn.assigns[:is_logged] do
      false ->
        conn
        |> redirect(to: "/")

      true ->
        conn
        |> render("list_groups.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super]
          }
        )
    end
  end

  @doc """
  Hosts List Page
  """
  def list_hosts(conn, _params) do
    case conn.assigns[:is_logged] do
      false ->
        conn
        |> redirect(to: "/")

      true ->
        conn
        |> render("list_hosts.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super]
          }
        )
    end
  end

  @doc """
  Deployments List Page
  """
  def list_deployments(conn, _params) do
    case conn.assigns[:is_logged] do
      false ->
        conn
        |> redirect(to: "/")

      true ->
        conn
        |> render("list_deployments.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super]
          }
        )
    end
  end

  @doc """
  Deployments Edit Page
  """
  def edit_deployment(conn, _params) do
    case conn.assigns[:is_logged] do
      false ->
        conn
        |> redirect(to: "/")

      true ->
        conn
        |> render("edit_deployment.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super]
          }
        )
    end
  end

  @doc """
  Deployments Add Page
  """
  def add_deployment(conn, _params) do
    case conn.assigns[:is_logged] do
      false ->
        conn
        |> redirect(to: "/")

      true ->
        conn
        |> render("add_deployment.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super]
          }
        )
    end
  end

  @doc """
  Teams List Page
  """
  def list_teams(conn, _params) do
    case conn.assigns[:is_super] do
      false ->
        conn
        |> redirect(to: "/")

      true ->
        users = UserModule.get_users(0, 1000)
        teams = TeamModule.get_teams(0, 1000)

        new_teams = []
        new_teams = for team <- teams do
          new_teams ++ %{
            id: team.id,
            uuid: team.uuid,
            name: team.name,
            description: team.description,
            count: UserModule.count_team_users(team.id),
            inserted_at: team.inserted_at,
            updated_at: team.updated_at
          }
        end

        conn
        |> render("list_teams.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            users: users,
            teams: new_teams
          }
        )
    end
  end

  @doc """
  Users List Page
  """
  def list_users(conn, _params) do
    case conn.assigns[:is_super] do
      false ->
        conn
        |> redirect(to: "/")

      true ->
        users = UserModule.get_users(0, 1000)

        conn
        |> render("list_users.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            users: users
          }
        )
    end
  end

  @doc """
  Settings Page
  """
  def settings(conn, _params) do
    case conn.assigns[:is_super] do
      false ->
        conn
        |> redirect(to: "/")

      true ->
        conn
        |> render("settings.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", ""),
            app_email: SettingsModule.get_config("app_email", "")
          }
        )
    end
  end
end
