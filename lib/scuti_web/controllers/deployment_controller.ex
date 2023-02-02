# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.DeploymentController do
  @moduledoc """
  Deployment Controller
  """

  use ScutiWeb, :controller

  require Logger

  alias Scuti.Module.DeploymentModule
  alias Scuti.Service.ValidatorService
  alias Scuti.Module.TeamModule
  alias Scuti.Exception.InvalidRequest

  # @default_list_limit "10"
  # @default_list_offset "0"

  plug :regular_user, only: [:list, :index, :create, :update, :delete]

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
  def create(conn, params) do
    try do
      validate_create_request(params)

      name = ValidatorService.get_str(params["name"], "")
      team_id = ValidatorService.get_int(params["team_id"], 0)
      hosts_filter = ValidatorService.get_str(params["hosts_filter"], "")
      host_groups_filter = ValidatorService.get_str(params["host_groups_filter"], "")
      patch_type = ValidatorService.get_str(params["patch_type"], "")
      pre_patch_script = ValidatorService.get_str(params["pre_patch_script"], "")
      patch_script = ValidatorService.get_str(params["patch_script"], "")
      post_patch_script = ValidatorService.get_str(params["post_patch_script"], "")
      post_patch_reboot_option = ValidatorService.get_str(params["post_patch_reboot_option"], "")
      rollout_strategy = ValidatorService.get_str(params["rollout_strategy"], "")
      rollout_strategy_value = ValidatorService.get_str(params["rollout_strategy_value"], "")
      schedule_type = ValidatorService.get_str(params["schedule_type"], "")
      schedule_time = ValidatorService.get_str(params["schedule_time"], "")

      {_, dt} = Timex.parse(schedule_time, "{ISO:Extended}")

      result =
        DeploymentModule.create_deployment(%{
          team_id: team_id,
          name: name,
          hosts_filter: hosts_filter,
          host_groups_filter: host_groups_filter,
          patch_type: patch_type,
          pkgs_to_upgrade: "~",
          pkgs_to_exclude: "~",
          pre_patch_script: pre_patch_script,
          patch_script: patch_script,
          post_patch_script: post_patch_script,
          post_patch_reboot_option: post_patch_reboot_option,
          rollout_strategy: rollout_strategy,
          rollout_strategy_value: rollout_strategy_value,
          schedule_type: schedule_type,
          schedule_time: dt,
          last_status: "unknown",
          last_run_at: DateTime.utc_now()
        })

      case result do
        {:error, msg} ->
          Logger.info(msg)
          raise InvalidRequest, message: "Invalid Request"

        {:ok, deployment} ->
          conn
          |> put_status(:created)
          |> render("create.json", %{deployment: deployment})
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
    team_id = ValidatorService.get_int(params["team_id"], 0)

    # hosts_filter = ValidatorService.get_str(params["hosts_filter"], "")
    # host_groups_filter = ValidatorService.get_str(params["host_groups_filter"], "")
    # patch_type = ValidatorService.get_str(params["patch_type"], "")
    # pre_patch_script = ValidatorService.get_str(params["pre_patch_script"], "")
    # patch_script = ValidatorService.get_str(params["patch_script"], "")
    # post_patch_script = ValidatorService.get_str(params["post_patch_script"], "")
    # post_patch_reboot_option = ValidatorService.get_str(params["post_patch_reboot_option"], "")
    # rollout_strategy = ValidatorService.get_str(params["rollout_strategy"], "")
    # rollout_strategy_value = ValidatorService.get_str(params["rollout_strategy_value"], "")
    # schedule_type = ValidatorService.get_str(params["schedule_type"], "")
    # schedule_time = ValidatorService.get_str(params["schedule_time"], "")

    if ValidatorService.is_empty(name) do
      raise InvalidRequest, message: "Deployment name is required"
    end

    if not ValidatorService.validate_int(team_id) do
      raise InvalidRequest, message: "Team is required"
    end

    if not TeamModule.validate_team_id(team_id) do
      raise InvalidRequest, message: "Team is required"
    end
  end
end
