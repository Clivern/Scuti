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
  alias Scuti.Module.HostGroupModule
  alias Scuti.Module.HostModule
  alias Scuti.Module.DeploymentModule
  alias Scuti.Module.TaskModule

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
        |> render("install.html",
          data: %{
            app_name: SettingsModule.get_config("app_name", "Scuti")
          }
        )
    end
  end

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
        |> redirect(to: "/admin/dashboard")

      {true, _} ->
        conn
        |> render("login.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_id: conn.assigns[:user_id],
            user_role: conn.assigns[:user_role],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", "") |> add_backslash_to_url
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
  Home Page
  """
  def home(conn, _params) do
    is_installed = InstallModule.is_installed()

    case is_installed do
      false ->
        conn
        |> redirect(to: "/install")

      true ->
        conn
        |> render("home.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_id: conn.assigns[:user_id],
            user_role: conn.assigns[:user_role],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            avatar_url: get_gavatar(conn.assigns[:user_email]),
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", "") |> add_backslash_to_url
          }
        )
    end
  end

  @doc """
  Not Found Page
  """
  def not_found(conn, _params) do
    is_installed = InstallModule.is_installed()

    case is_installed do
      false ->
        conn
        |> redirect(to: "/install")

      true ->
        conn
        |> render("404.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_id: conn.assigns[:user_id],
            user_role: conn.assigns[:user_role],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            avatar_url: get_gavatar(conn.assigns[:user_email]),
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", "") |> add_backslash_to_url
          }
        )
    end
  end

  @doc """
  Profile Page
  """
  def profile(conn, _params) do
    case conn.assigns[:is_logged] do
      false ->
        conn
        |> redirect(to: "/login")

      true ->
        conn
        |> render("profile.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_id: conn.assigns[:user_id],
            user_role: conn.assigns[:user_role],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            user_api_key: conn.assigns[:user_api_key],
            avatar_url: get_gavatar(conn.assigns[:user_email]),
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", "") |> add_backslash_to_url
          }
        )
    end
  end

  @doc """
  Dashboard Page
  """
  def dashboard(conn, _params) do
    case conn.assigns[:is_super] do
      false ->
        conn
        |> redirect(to: "/login")

      true ->
        conn
        |> render("dashboard.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_id: conn.assigns[:user_id],
            user_role: conn.assigns[:user_role],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            avatar_url: get_gavatar(conn.assigns[:user_email]),
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", "") |> add_backslash_to_url
          }
        )
    end
  end

  @doc """
  Groups Page
  """
  def groups(conn, _params) do
    case conn.assigns[:is_super] do
      false ->
        conn
        |> redirect(to: "/login")

      true ->
        conn
        |> render("groups.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_id: conn.assigns[:user_id],
            user_role: conn.assigns[:user_role],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            avatar_url: get_gavatar(conn.assigns[:user_email]),
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", "") |> add_backslash_to_url
          }
        )
    end
  end

  @doc """
  Group Page
  """
  def group(conn, _params) do
    case conn.assigns[:is_super] do
      false ->
        conn
        |> redirect(to: "/login")

      true ->
        conn
        |> render("group.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_id: conn.assigns[:user_id],
            user_role: conn.assigns[:user_role],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            avatar_url: get_gavatar(conn.assigns[:user_email]),
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", "") |> add_backslash_to_url
          }
        )
    end
  end

  @doc """
  Deployments Page
  """
  def deployments(conn, _params) do
    case conn.assigns[:is_super] do
      false ->
        conn
        |> redirect(to: "/login")

      true ->
        conn
        |> render("deployments.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_id: conn.assigns[:user_id],
            user_role: conn.assigns[:user_role],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            avatar_url: get_gavatar(conn.assigns[:user_email]),
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", "") |> add_backslash_to_url
          }
        )
    end
  end

  @doc """
  Deployment Page
  """
  def deployment(conn, _params) do
    case conn.assigns[:is_super] do
      false ->
        conn
        |> redirect(to: "/login")

      true ->
        conn
        |> render("deployment.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_id: conn.assigns[:user_id],
            user_role: conn.assigns[:user_role],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            avatar_url: get_gavatar(conn.assigns[:user_email]),
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", "") |> add_backslash_to_url
          }
        )
    end
  end

  @doc """
  Add Deployment Page
  """
  def add_deployment(conn, _params) do
    case conn.assigns[:is_super] do
      false ->
        conn
        |> redirect(to: "/login")

      true ->
        conn
        |> render("add_deployment.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_id: conn.assigns[:user_id],
            user_role: conn.assigns[:user_role],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            avatar_url: get_gavatar(conn.assigns[:user_email]),
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", "") |> add_backslash_to_url
          }
        )
    end
  end

  @doc """
  Edit Deployment Page
  """
  def edit_deployment(conn, _params) do
    case conn.assigns[:is_super] do
      false ->
        conn
        |> redirect(to: "/login")

      true ->
        conn
        |> render("edit_deployment.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_id: conn.assigns[:user_id],
            user_role: conn.assigns[:user_role],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            avatar_url: get_gavatar(conn.assigns[:user_email]),
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", "") |> add_backslash_to_url
          }
        )
    end
  end

  @doc """
  Users Page
  """
  def users(conn, _params) do
    case conn.assigns[:is_super] do
      false ->
        conn
        |> redirect(to: "/login")

      true ->
        conn
        |> render("users.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_id: conn.assigns[:user_id],
            user_role: conn.assigns[:user_role],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            avatar_url: get_gavatar(conn.assigns[:user_email]),
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", "") |> add_backslash_to_url
          }
        )
    end
  end

  @doc """
  Teams Page
  """
  def teams(conn, _params) do
    case conn.assigns[:is_super] do
      false ->
        conn
        |> redirect(to: "/login")

      true ->
        conn
        |> render("teams.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_id: conn.assigns[:user_id],
            user_role: conn.assigns[:user_role],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            avatar_url: get_gavatar(conn.assigns[:user_email]),
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", "") |> add_backslash_to_url
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
        |> redirect(to: "/login")

      true ->
        conn
        |> render("settings.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_id: conn.assigns[:user_id],
            user_role: conn.assigns[:user_role],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            avatar_url: get_gavatar(conn.assigns[:user_email]),
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", "") |> add_backslash_to_url,
            app_email: SettingsModule.get_config("app_email", "")
          }
        )
    end
  end

  defp get_gavatar(nil) do
    ""
  end

  defp get_gavatar(email) do
    hash = Base.encode16(:crypto.hash(:sha256, email)) |> String.downcase()
    "https://gravatar.com/avatar/#{hash}?s=200"
  end

  defp add_backslash_to_url(nil) do
    ""
  end

  defp add_backslash_to_url(url) do
    if String.last(url) == "/" do
      String.slice(url, 0..-2//1)
    else
      url
    end
  end
end
