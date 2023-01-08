# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.PageController do
  @moduledoc """
  Page Controller
  """
  use ScutiWeb, :controller

  alias Scuti.Module.InstallModule
  alias Scuti.Service.AuthService

  @doc """
  Login Page
  """
  def login(conn, _params) do
    is_installed = InstallModule.is_installed()

    case {is_installed, conn.assigns[:is_logged]} do
      {false, _} ->
        redirect(conn, to: "/install")

      {_, true} ->
        redirect(conn, to: "/")

      {true, _} ->
        render(conn, "login.html",
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
        redirect(conn, to: "/")

      false ->
        render(conn, "install.html")
    end
  end

  @doc """
  Home Page
  """
  def home(conn, _params) do
    is_installed = InstallModule.is_installed()

    case is_installed do
      false ->
        redirect(conn, to: "/install")

      true ->
        render(conn, "home.html",
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
    render(conn, "list_groups.html",
      data: %{
        is_logged: conn.assigns[:is_logged],
        is_super: conn.assigns[:is_super]
      }
    )
  end

  @doc """
  Host Groups Edit Page

  Ignore
  """

  # def edit_group(conn, _params) do
  #   render(conn, "edit_group.html",
  #     data: %{
  #       is_logged: conn.assigns[:is_logged],
  #       is_super: conn.assigns[:is_super]
  #     }
  #   )
  # end

  @doc """
  Host Groups Add Page

  Ignore
  """

  # def add_group(conn, _params) do
  #   render(conn, "add_group.html",
  #     data: %{
  #       is_logged: conn.assigns[:is_logged],
  #       is_super: conn.assigns[:is_super]
  #     }
  #   )
  # end

  @doc """
  Hosts List Page
  """
  def list_hosts(conn, _params) do
    render(conn, "list_hosts.html",
      data: %{
        is_logged: conn.assigns[:is_logged],
        is_super: conn.assigns[:is_super]
      }
    )
  end

  @doc """
  Hosts Edit Page

  Ignore
  """

  # def edit_host(conn, _params) do
  #   render(conn, "edit_host.html",
  #     data: %{
  #       is_logged: conn.assigns[:is_logged],
  #       is_super: conn.assigns[:is_super]
  #     }
  #   )
  # end

  @doc """
  Hosts Add Page

  Ignore
  """

  # def add_host(conn, _params) do
  #   render(conn, "add_host.html",
  #     data: %{
  #       is_logged: conn.assigns[:is_logged],
  #       is_super: conn.assigns[:is_super]
  #     }
  #   )
  # end

  @doc """
  Deployments List Page
  """
  def list_deployments(conn, _params) do
    render(conn, "list_deployments.html",
      data: %{
        is_logged: conn.assigns[:is_logged],
        is_super: conn.assigns[:is_super]
      }
    )
  end

  @doc """
  Deployments Edit Page
  """
  def edit_deployment(conn, _params) do
    render(conn, "edit_deployment.html",
      data: %{
        is_logged: conn.assigns[:is_logged],
        is_super: conn.assigns[:is_super]
      }
    )
  end

  @doc """
  Deployments Add Page
  """
  def add_deployment(conn, _params) do
    render(conn, "add_deployment.html",
      data: %{
        is_logged: conn.assigns[:is_logged],
        is_super: conn.assigns[:is_super]
      }
    )
  end

  @doc """
  Teams List Page
  """
  def list_teams(conn, _params) do
    render(conn, "list_teams.html",
      data: %{
        is_logged: conn.assigns[:is_logged],
        is_super: conn.assigns[:is_super]
      }
    )
  end

  @doc """
  Teams Edit Page

  Ignore
  """

  # def edit_team(conn, _params) do
  #   render(conn, "edit_team.html",
  #     data: %{
  #       is_logged: conn.assigns[:is_logged],
  #       is_super: conn.assigns[:is_super]
  #     }
  #   )
  # end

  @doc """
  Teams Add Page

  Ignore
  """

  # def add_team(conn, _params) do
  #   render(conn, "add_team.html",
  #     data: %{
  #       is_logged: conn.assigns[:is_logged],
  #       is_super: conn.assigns[:is_super]
  #     }
  #   )
  # end

  @doc """
  Users List Page
  """
  def list_users(conn, _params) do
    render(conn, "list_users.html",
      data: %{
        is_logged: conn.assigns[:is_logged],
        is_super: conn.assigns[:is_super]
      }
    )
  end

  @doc """
  Users Edit Page

  Ignore
  """

  # def edit_user(conn, _params) do
  #   render(conn, "edit_user.html",
  #     data: %{
  #       is_logged: conn.assigns[:is_logged],
  #       is_super: conn.assigns[:is_super]
  #     }
  #   )
  # end

  @doc """
  Users Add Page

  Ignore
  """

  # def add_user(conn, _params) do
  #   render(conn, "add_user.html",
  #     data: %{
  #       is_logged: conn.assigns[:is_logged],
  #       is_super: conn.assigns[:is_super]
  #     }
  #   )
  # end

  @doc """
  Settings Page
  """
  def settings(conn, _params) do
    render(conn, "settings.html",
      data: %{
        is_logged: conn.assigns[:is_logged],
        is_super: conn.assigns[:is_super]
      }
    )
  end
end
