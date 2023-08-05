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
  alias Scuti.Module.PermissionModule
  alias Scuti.Module.TeamModule
  alias Scuti.Service.ValidatorService

  @default_list_limit "10"
  @default_list_offset "0"
  @name_min_length 2
  @name_max_length 60
  @description_min_length 2
  @description_max_length 250

  plug :regular_user when action in [:list, :index, :create, :update, :delete]
  plug :access_check when action in [:index, :update, :delete]

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

  defp access_check(conn, _opts) do
    Logger.info("Validate if user can access deployment")

    if not PermissionModule.can_access_deployment_uuid(
         :deployment,
         conn.assigns[:user_role],
         conn.params["uuid"],
         conn.assigns[:user_id]
       ) do
      Logger.info("User doesn't own the deployment")

      conn
      |> put_status(:forbidden)
      |> render("error.json", %{message: "Forbidden Access"})
      |> halt
    else
      Logger.info("User can access the deployment")

      conn
    end
  end

  @doc """
  List Action Endpoint
  """
  def list(conn, params) do
    limit = params["limit"] || @default_list_limit
    offset = params["offset"] || @default_list_offset

    {deployments, count} =
      if conn.assigns[:is_super] do
        {DeploymentModule.get_deployments(offset, limit), DeploymentModule.count_deployments()}
      else
        {DeploymentModule.get_user_deployments(conn.assigns[:user_id], offset, limit),
         DeploymentModule.count_user_deployments(conn.assigns[:user_id])}
      end

    render(conn, "list.json", %{
      deployments: deployments,
      metadata: %{
        limit: limit,
        offset: offset,
        totalCount: count
      }
    })
  end

  @doc """
  Create Action Endpoint
  """
  def create(conn, params) do
    case validate_create_request(params) do
      {:ok, _} ->
        result =
          DeploymentModule.create_deployment(%{
            name: params["name"],
            description: params["description"],
            hosts_filter: params["hosts_filter"],
            host_groups_filter: params["host_groups_filter"],
            patch_type: params["patch_type"],
            pre_patch_script: params["pre_patch_script"],
            patch_script: params["patch_script"],
            post_patch_script: params["post_patch_script"],
            post_patch_reboot_option: params["post_patch_reboot_option"],
            rollout_strategy: params["rollout_strategy"],
            rollout_strategy_value: params["rollout_strategy_value"],
            schedule_type: params["schedule_type"],
            schedule_time: params["schedule_time"],
            recurrence: params["recurrence"],
            last_status: "unknown",
            last_run_at: DateTime.utc_now(),
            team_id: TeamModule.get_team_id_with_uuid(params["team_id"])
          })

        case result do
          {:ok, deployment} ->
            conn
            |> put_status(:created)
            |> render("index.json", %{deployment: deployment})

          {:error, msg} ->
            conn
            |> put_status(:bad_request)
            |> render("error.json", %{message: msg})
        end

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", %{message: reason})
    end
  end

  @doc """
  Index Action Endpoint
  """
  def index(conn, %{"uuid" => uuid}) do
    case DeploymentModule.get_deployment_by_uuid(uuid) do
      {:not_found, msg} ->
        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: msg})

      {:ok, deployment} ->
        conn
        |> put_status(:ok)
        |> render("index.json", %{deployment: deployment})
    end
  end

  @doc """
  Update Action Endpoint
  """
  def update(conn, params) do
    case validate_update_request(params, params["uuid"]) do
      {:ok, _} ->
        result =
          DeploymentModule.update_deployment(%{
            uuid: params["uuid"],
            name: params["name"],
            description: params["description"],
            hosts_filter: params["hosts_filter"],
            host_groups_filter: params["host_groups_filter"],
            patch_type: params["patch_type"],
            pre_patch_script: params["pre_patch_script"],
            patch_script: params["patch_script"],
            post_patch_script: params["post_patch_script"],
            post_patch_reboot_option: params["post_patch_reboot_option"],
            rollout_strategy: params["rollout_strategy"],
            rollout_strategy_value: params["rollout_strategy_value"],
            schedule_type: params["schedule_type"],
            schedule_time: params["schedule_time"],
            recurrence: params["recurrence"]
          })

        case result do
          {:ok, deployment} ->
            conn
            |> put_status(:ok)
            |> render("index.json", %{deployment: deployment})

          {:error, msg} ->
            conn
            |> put_status(:bad_request)
            |> render("error.json", %{message: msg})
        end

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", %{message: reason})
    end
  end

  @doc """
  Delete Action Endpoint
  """
  def delete(conn, %{"uuid" => uuid}) do
    Logger.info("Attempt to delete deployment with uuid #{uuid}")

    case DeploymentModule.delete_deployment_by_uuid(uuid) do
      {:not_found, msg} ->
        Logger.info("Deployment with uuid #{uuid} not found")

        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: msg})

      {:ok, _} ->
        Logger.info("Deployment with uuid #{uuid} is deleted")

        conn
        |> send_resp(:no_content, "")
    end
  end

  defp validate_create_request(params) do
    errs = %{
      name_required: "Deployment name is required",
      name_invalid: "Deployment name is invalid",
      description_required: "Deployment description is required",
      description_invalid: "Deployment description is invalid",
      hosts_filter_required: "Deployment host filter is required",
      hosts_filter_invalid: "Deployment host filter is invalid",
      host_groups_filter_required: "Deployment group filter is required",
      host_groups_filter_invalid: "Deployment group filter is invalid",
      patch_type_required: "Deployment patch type is required",
      patch_type_invalid: "Deployment patch type is invalid",
      pre_patch_script_required: "Deployment pre patch script is required",
      patch_script_required: "Deployment patch script is required",
      post_patch_script_required: "Deployment post patch script is required",
      post_patch_reboot_option_required: "Deployment post patch reboot option is required",
      post_patch_reboot_option_invalid: "Deployment post patch reboot option is invalid",
      rollout_strategy_required: "Deployment rollout strategy is required",
      rollout_strategy_invalid: "Deployment rollout strategy is invalid",
      rollout_strategy_value_required: "Deployment rollout strategy value is required",
      schedule_type_required: "Deployment schedule type is required",
      schedule_type_invalid: "Deployment schedule type is invalid",
      schedule_time_required: "Deployment schedule time is required",
      recurrence_invalid: "Recurrence is invalid",
      team_id_required: "Team id is required",
      team_id_invalid: "Team id is invalid"
    }

    with {:ok, _} <- ValidatorService.is_string?(params["name"], errs.name_required),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["name"],
             @name_min_length,
             @name_max_length,
             errs.name_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_string?(params["description"], errs.description_required),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["description"],
             @description_min_length,
             @description_max_length,
             errs.description_invalid
           ),
         {:ok, _} <- ValidatorService.is_string?(params["team_id"], errs.team_id_required),
         {:ok, _} <- ValidatorService.is_uuid?(params["team_id"], errs.team_id_invalid),
         {:ok, _} <-
           ValidatorService.is_string?(params["hosts_filter"], errs.hosts_filter_required),
         {:ok, _} <-
           ValidatorService.is_labels?(params["hosts_filter"], errs.hosts_filter_invalid),
         {:ok, _} <-
           ValidatorService.is_string?(
             params["host_groups_filter"],
             errs.host_groups_filter_required
           ),
         {:ok, _} <-
           ValidatorService.is_labels?(
             params["host_groups_filter"],
             errs.host_groups_filter_invalid
           ),
         {:ok, _} <- ValidatorService.is_string?(params["patch_type"], errs.patch_type_required),
         {:ok, _} <-
           ValidatorService.in?(
             params["patch_type"],
             ["os_upgrade", "distribution_upgrade", "custom_system_patch"],
             errs.patch_type_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_string?(params["pre_patch_script"], errs.pre_patch_script_required),
         {:ok, _} <-
           ValidatorService.is_string?(params["patch_script"], errs.patch_script_required),
         {:ok, _} <-
           ValidatorService.is_string?(
             params["post_patch_script"],
             errs.post_patch_script_required
           ),
         {:ok, _} <-
           ValidatorService.is_string?(
             params["post_patch_reboot_option"],
             errs.post_patch_reboot_option_required
           ),
         {:ok, _} <-
           ValidatorService.in?(
             params["post_patch_reboot_option"],
             ["always", "only_if_needed", "never"],
             errs.post_patch_reboot_option_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_string?(params["rollout_strategy"], errs.rollout_strategy_required),
         {:ok, _} <-
           ValidatorService.in?(
             params["rollout_strategy"],
             ["one_by_one", "all_at_once", "percent", "count"],
             errs.rollout_strategy_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_string?(
             params["rollout_strategy_value"],
             errs.rollout_strategy_value_required
           ),
         {:ok, _} <-
           ValidatorService.is_string?(params["schedule_type"], errs.schedule_type_required),
         {:ok, _} <-
           ValidatorService.in?(
             params["schedule_type"],
             ["once", "recursive"],
             errs.schedule_type_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_string?(params["schedule_time"], errs.schedule_time_required),
         {:ok, _} <-
           ValidatorService.is_string?(params["recurrence"], errs.recurrence_invalid) do
      {:ok, ""}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_update_request(params, deployment_id) do
    errs = %{
      name_required: "Deployment name is required",
      name_invalid: "Deployment name is invalid",
      description_required: "Deployment description is required",
      description_invalid: "Deployment description is invalid",
      hosts_filter_required: "Deployment host filter is required",
      hosts_filter_invalid: "Deployment host filter is invalid",
      host_groups_filter_required: "Deployment group filter is required",
      host_groups_filter_invalid: "Deployment group filter is invalid",
      patch_type_required: "Deployment patch type is required",
      patch_type_invalid: "Deployment patch type is invalid",
      pre_patch_script_required: "Deployment pre patch script is required",
      patch_script_required: "Deployment patch script is required",
      post_patch_script_required: "Deployment post patch script is required",
      post_patch_reboot_option_required: "Deployment post patch reboot option is required",
      post_patch_reboot_option_invalid: "Deployment post patch reboot option is invalid",
      rollout_strategy_required: "Deployment rollout strategy is required",
      rollout_strategy_invalid: "Deployment rollout strategy is invalid",
      rollout_strategy_value_required: "Deployment rollout strategy value is required",
      schedule_type_required: "Deployment schedule type is required",
      schedule_type_invalid: "Deployment schedule type is invalid",
      schedule_time_required: "Deployment schedule time is required",
      recurrence_invalid: "Recurrence is invalid",
      deployment_id_required: "Deployment id is required",
      deployment_id_invalid: "Deployment id is invalid"
    }

    with {:ok, _} <- ValidatorService.is_string?(params["name"], errs.name_required),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["name"],
             @name_min_length,
             @name_max_length,
             errs.name_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_string?(params["description"], errs.description_required),
         {:ok, _} <-
           ValidatorService.is_length_between?(
             params["description"],
             @description_min_length,
             @description_max_length,
             errs.description_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_string?(params["hosts_filter"], errs.hosts_filter_required),
         {:ok, _} <-
           ValidatorService.is_labels?(params["hosts_filter"], errs.hosts_filter_invalid),
         {:ok, _} <-
           ValidatorService.is_string?(
             params["host_groups_filter"],
             errs.host_groups_filter_required
           ),
         {:ok, _} <-
           ValidatorService.is_labels?(
             params["host_groups_filter"],
             errs.host_groups_filter_invalid
           ),
         {:ok, _} <- ValidatorService.is_string?(params["patch_type"], errs.patch_type_required),
         {:ok, _} <-
           ValidatorService.in?(
             params["patch_type"],
             ["os_upgrade", "distribution_upgrade", "custom_system_patch"],
             errs.patch_type_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_string?(params["pre_patch_script"], errs.pre_patch_script_required),
         {:ok, _} <-
           ValidatorService.is_string?(params["patch_script"], errs.patch_script_required),
         {:ok, _} <-
           ValidatorService.is_string?(
             params["post_patch_script"],
             errs.post_patch_script_required
           ),
         {:ok, _} <-
           ValidatorService.is_string?(
             params["post_patch_reboot_option"],
             errs.post_patch_reboot_option_required
           ),
         {:ok, _} <-
           ValidatorService.in?(
             params["post_patch_reboot_option"],
             ["always", "only_if_needed", "never"],
             errs.post_patch_reboot_option_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_string?(params["rollout_strategy"], errs.rollout_strategy_required),
         {:ok, _} <-
           ValidatorService.in?(
             params["rollout_strategy"],
             ["one_by_one", "all_at_once", "percent", "count"],
             errs.rollout_strategy_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_string?(
             params["rollout_strategy_value"],
             errs.rollout_strategy_value_required
           ),
         {:ok, _} <-
           ValidatorService.is_string?(params["schedule_type"], errs.schedule_type_required),
         {:ok, _} <-
           ValidatorService.in?(
             params["schedule_type"],
             ["once", "recursive"],
             errs.schedule_type_invalid
           ),
         {:ok, _} <-
           ValidatorService.is_string?(params["schedule_time"], errs.schedule_time_required),
         {:ok, _} <-
           ValidatorService.is_string?(params["recurrence"], errs.recurrence_invalid),
         {:ok, _} <- ValidatorService.is_string?(deployment_id, errs.deployment_id_required),
         {:ok, _} <- ValidatorService.is_uuid?(deployment_id, errs.deployment_id_invalid) do
      {:ok, ""}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
