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
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email]
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
        |> redirect(to: "/install")

      true ->
        conn
        |> render("home.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email]
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
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email]
          }
        )
    end
  end

  @doc """
  Dashboard Page
  """
  def dashboard(conn, _params) do
    case conn.assigns[:is_logged] do
      false ->
        conn
        |> redirect(to: "/")

      true ->
        conn
        |> render("dashboard.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email]
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
        |> redirect(to: "/")

      true ->
        conn
        |> render("profile.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email]
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
        teams_ids = []
        new_groups = []
        user_teams = HostGroupModule.get_user_teams(conn.assigns[:user_id])

        teams_ids =
          for user_team <- user_teams do
            teams_ids ++ user_team.id
          end

        groups = HostGroupModule.get_groups_by_teams(teams_ids, 0, 1000)

        new_groups =
          for group <- groups do
            new_groups ++
              %{
                id: group.id,
                uuid: group.uuid,
                name: group.name,
                host_count: HostGroupModule.count_hosts_by_host_group(group.id),
                labels: group.labels,
                inserted_at: group.inserted_at,
                updated_at: group.updated_at
              }
          end

        conn
        |> render("list_groups.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            groups: new_groups,
            user_teams: user_teams
          }
        )
    end
  end

  @doc """
  Host Groups View Page
  """
  def view_group(conn, %{"uuid" => uuid}) do
    case conn.assigns[:is_logged] do
      false ->
        conn
        |> redirect(to: "/")

      true ->
        group = HostGroupModule.get_group_by_uuid(uuid)

        case group do
          nil ->
            conn
            |> redirect(to: "/404")

          _ ->
            hosts = HostModule.get_hosts_by_group(group.id, 0, 10000)

            conn
            |> render("view_group.html",
              data: %{
                is_logged: conn.assigns[:is_logged],
                is_super: conn.assigns[:is_super],
                user_name: conn.assigns[:user_name],
                user_email: conn.assigns[:user_email],
                group: group,
                hosts: hosts
              }
            )
        end
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
        teams_ids = []
        user_teams = HostGroupModule.get_user_teams(conn.assigns[:user_id])

        teams_ids =
          for user_team <- user_teams do
            teams_ids ++ user_team.id
          end

        deployments = DeploymentModule.get_deployments_by_teams(teams_ids, 0, 1000)

        conn
        |> render("list_deployments.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            deployments: deployments,
            user_teams: user_teams
          }
        )
    end
  end

  @doc """
  Deployments Edit Page
  """
  def edit_deployment(conn, %{uuid: _uuid}) do
    case conn.assigns[:is_logged] do
      false ->
        conn
        |> redirect(to: "/")

      true ->
        conn
        |> render("edit_deployment.html",
          data: %{
            is_logged: conn.assigns[:is_logged],
            is_super: conn.assigns[:is_super],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email]
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
            is_super: conn.assigns[:is_super],
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email]
          }
        )
    end
  end

  @doc """
  Deployments View Page
  """
  def view_deployment(conn, %{"uuid" => uuid}) do
    case conn.assigns[:is_logged] do
      false ->
        conn
        |> redirect(to: "/")

      true ->
        deployment = DeploymentModule.get_deployment_by_uuid(uuid)

        hosts = DeploymentModule.get_deployment_target_hosts(deployment.id)

        tasks = TaskModule.get_deployment_tasks(deployment.id)

        history =
          for task <- tasks do
            result = Jason.decode!(task.result)

            total =
              if result["total_hosts"] == 0 do
                1
              else
                result["total_hosts"]
              end

            %{
              id: task.id,
              uuid: task.uuid,
              total_hosts: result["total_hosts"],
              updated_hosts: result["updated_hosts"],
              failed_hosts: result["failed_hosts"],
              progress:
                Float.round((result["updated_hosts"] + result["failed_hosts"]) / total * 100, 0),
              status: task.status,
              run_at: task.run_at
            }
          end

        case deployment do
          nil ->
            conn
            |> redirect(to: "/404")

          _ ->
            conn
            |> render("view_deployment.html",
              data: %{
                is_logged: conn.assigns[:is_logged],
                is_super: conn.assigns[:is_super],
                user_name: conn.assigns[:user_name],
                user_email: conn.assigns[:user_email],
                deployment: deployment,
                hosts: hosts,
                history: history
              }
            )
        end
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

        new_teams =
          for team <- teams do
            new_teams ++
              %{
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
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
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
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
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
            user_name: conn.assigns[:user_name],
            user_email: conn.assigns[:user_email],
            app_name: SettingsModule.get_config("app_name", ""),
            app_url: SettingsModule.get_config("app_url", ""),
            app_email: SettingsModule.get_config("app_email", "")
          }
        )
    end
  end
end
