# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.DeploymentContextTest do
  @moduledoc """
  Deployment Context Test Cases
  """
  use ExUnit.Case

  alias Scuti.Context.TeamContext
  alias Scuti.Context.DeploymentContext

  # Init
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Scuti.Repo)
  end

  # Test Cases
  describe "new_deployment/1" do
    test "new_deployment/1 test cases" do
      deployment =
        DeploymentContext.new_deployment(%{
          team_id: 1,
          name: "~name~",
          hosts_list: "~hosts_list~",
          host_groups_list: "~host_groups_list~",
          hosts_filter: "~hosts_filter~",
          host_groups_filter: "~host_groups_filter~",
          patch_type: "~patch_type~",
          pkgs_to_upgrade: "~pkgs_to_upgrade~",
          pkgs_to_exclude: "~pkgs_to_exclude~",
          pre_patch_script: "~pre_patch_script~",
          patch_script: "~patch_script~",
          post_patch_script: "~post_patch_script~",
          post_patch_reboot_option: "~post_patch_reboot_option~",
          rollout_strategy: "~rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~schedule_type~",
          schedule_time: "~schedule_time~",
          last_status: "~last_status~",
          last_run_at: "~last_run_at~"
        })

      assert deployment.team_id == 1
      assert deployment.name == "~name~"
      assert deployment.hosts_list == "~hosts_list~"
      assert deployment.host_groups_list == "~host_groups_list~"
      assert deployment.hosts_filter == "~hosts_filter~"
      assert deployment.host_groups_filter == "~host_groups_filter~"
      assert deployment.patch_type == "~patch_type~"
      assert deployment.pkgs_to_upgrade == "~pkgs_to_upgrade~"
      assert deployment.pkgs_to_exclude == "~pkgs_to_exclude~"
      assert deployment.pre_patch_script == "~pre_patch_script~"
      assert deployment.patch_script == "~patch_script~"
      assert deployment.post_patch_script == "~post_patch_script~"
      assert deployment.post_patch_reboot_option == "~post_patch_reboot_option~"
      assert deployment.rollout_strategy == "~rollout_strategy~"
      assert deployment.schedule_type == "~schedule_type~"
      assert deployment.schedule_time == "~schedule_time~"
      assert deployment.last_status == "~last_status~"
      assert deployment.last_run_at == "~last_run_at~"
      assert is_binary(deployment.uuid)
    end
  end

  describe "new_meta/1" do
    test "new_meta/1 test cases" do
      meta =
        DeploymentContext.new_meta(%{
          key: "~meta_key~",
          value: "~meta_value~",
          deployment_id: 1
        })

      assert meta.deployment_id == 1
      assert meta.key == "~meta_key~"
      assert meta.value == "~meta_value~"
    end
  end

  describe "create_deployment/1" do
    test "create_deployment/1 test cases" do
      attrs =
        TeamContext.new_team(%{
          name: "Team 2",
          description: "Description 2"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      attr =
        DeploymentContext.new_deployment(%{
          team_id: team.id,
          name: "~name~",
          hosts_list: "~hosts_list~",
          host_groups_list: "~host_groups_list~",
          hosts_filter: "~hosts_filter~",
          host_groups_filter: "~host_groups_filter~",
          patch_type: "~patch_type~",
          pkgs_to_upgrade: "~pkgs_to_upgrade~",
          pkgs_to_exclude: "~pkgs_to_exclude~",
          pre_patch_script: "~pre_patch_script~",
          patch_script: "~patch_script~",
          post_patch_script: "~post_patch_script~",
          post_patch_reboot_option: "~post_patch_reboot_option~",
          rollout_strategy: "~rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~schedule_type~",
          schedule_time: DateTime.utc_now(),
          last_status: "~last_status~",
          last_run_at: DateTime.utc_now()
        })

      {status, deployment} = DeploymentContext.create_deployment(attr)

      assert status == :ok
      assert deployment.team_id == team.id
      assert deployment.name == "~name~"
      assert deployment.hosts_list == "~hosts_list~"
      assert deployment.host_groups_list == "~host_groups_list~"
      assert deployment.hosts_filter == "~hosts_filter~"
      assert deployment.host_groups_filter == "~host_groups_filter~"
      assert deployment.patch_type == "~patch_type~"
      assert deployment.pkgs_to_upgrade == "~pkgs_to_upgrade~"
      assert deployment.pkgs_to_exclude == "~pkgs_to_exclude~"
      assert deployment.pre_patch_script == "~pre_patch_script~"
      assert deployment.patch_script == "~patch_script~"
      assert deployment.post_patch_script == "~post_patch_script~"
      assert deployment.post_patch_reboot_option == "~post_patch_reboot_option~"
      assert deployment.rollout_strategy == "~rollout_strategy~"
      assert deployment.schedule_type == "~schedule_type~"
      assert deployment.last_status == "~last_status~"
      assert is_binary(deployment.uuid)
    end
  end

  describe "get_deployment_by_id/1" do
    test "get_deployment_by_id/1 test cases" do
      attrs =
        TeamContext.new_team(%{
          name: "Team 2",
          description: "Description 2"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      attr =
        DeploymentContext.new_deployment(%{
          team_id: team.id,
          name: "~name~",
          hosts_list: "~hosts_list~",
          host_groups_list: "~host_groups_list~",
          hosts_filter: "~hosts_filter~",
          host_groups_filter: "~host_groups_filter~",
          patch_type: "~patch_type~",
          pkgs_to_upgrade: "~pkgs_to_upgrade~",
          pkgs_to_exclude: "~pkgs_to_exclude~",
          pre_patch_script: "~pre_patch_script~",
          patch_script: "~patch_script~",
          post_patch_script: "~post_patch_script~",
          post_patch_reboot_option: "~post_patch_reboot_option~",
          rollout_strategy: "~rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~schedule_type~",
          schedule_time: DateTime.utc_now(),
          last_status: "~last_status~",
          last_run_at: DateTime.utc_now()
        })

      {status, deployment} = DeploymentContext.create_deployment(attr)

      assert status == :ok
      assert deployment.team_id == team.id
      assert deployment.name == "~name~"
      assert deployment.hosts_list == "~hosts_list~"
      assert deployment.host_groups_list == "~host_groups_list~"
      assert deployment.hosts_filter == "~hosts_filter~"
      assert deployment.host_groups_filter == "~host_groups_filter~"
      assert deployment.patch_type == "~patch_type~"
      assert deployment.pkgs_to_upgrade == "~pkgs_to_upgrade~"
      assert deployment.pkgs_to_exclude == "~pkgs_to_exclude~"
      assert deployment.pre_patch_script == "~pre_patch_script~"
      assert deployment.patch_script == "~patch_script~"
      assert deployment.post_patch_script == "~post_patch_script~"
      assert deployment.post_patch_reboot_option == "~post_patch_reboot_option~"
      assert deployment.rollout_strategy == "~rollout_strategy~"
      assert deployment.schedule_type == "~schedule_type~"
      assert deployment.last_status == "~last_status~"
      assert is_binary(deployment.uuid)

      assert DeploymentContext.get_deployment_by_id(deployment.id) == deployment
    end
  end

  describe "get_deployment_by_uuid/1" do
    test "get_deployment_by_uuid/1 test cases" do
      attrs =
        TeamContext.new_team(%{
          name: "Team 2",
          description: "Description 2"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      attr =
        DeploymentContext.new_deployment(%{
          team_id: team.id,
          name: "~name~",
          hosts_list: "~hosts_list~",
          host_groups_list: "~host_groups_list~",
          hosts_filter: "~hosts_filter~",
          host_groups_filter: "~host_groups_filter~",
          patch_type: "~patch_type~",
          pkgs_to_upgrade: "~pkgs_to_upgrade~",
          pkgs_to_exclude: "~pkgs_to_exclude~",
          pre_patch_script: "~pre_patch_script~",
          patch_script: "~patch_script~",
          post_patch_script: "~post_patch_script~",
          post_patch_reboot_option: "~post_patch_reboot_option~",
          rollout_strategy: "~rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~schedule_type~",
          schedule_time: DateTime.utc_now(),
          last_status: "~last_status~",
          last_run_at: DateTime.utc_now()
        })

      {status, deployment} = DeploymentContext.create_deployment(attr)

      assert status == :ok
      assert deployment.team_id == team.id
      assert deployment.name == "~name~"
      assert deployment.hosts_list == "~hosts_list~"
      assert deployment.host_groups_list == "~host_groups_list~"
      assert deployment.hosts_filter == "~hosts_filter~"
      assert deployment.host_groups_filter == "~host_groups_filter~"
      assert deployment.patch_type == "~patch_type~"
      assert deployment.pkgs_to_upgrade == "~pkgs_to_upgrade~"
      assert deployment.pkgs_to_exclude == "~pkgs_to_exclude~"
      assert deployment.pre_patch_script == "~pre_patch_script~"
      assert deployment.patch_script == "~patch_script~"
      assert deployment.post_patch_script == "~post_patch_script~"
      assert deployment.post_patch_reboot_option == "~post_patch_reboot_option~"
      assert deployment.rollout_strategy == "~rollout_strategy~"
      assert deployment.schedule_type == "~schedule_type~"
      assert deployment.last_status == "~last_status~"
      assert is_binary(deployment.uuid)

      assert DeploymentContext.get_deployment_by_uuid(deployment.uuid) == deployment
    end
  end

  describe "update_deployment/2" do
    test "update_deployment/2 test cases" do
      attrs =
        TeamContext.new_team(%{
          name: "Team 2",
          description: "Description 2"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      attr =
        DeploymentContext.new_deployment(%{
          team_id: team.id,
          name: "~name~",
          hosts_list: "~hosts_list~",
          host_groups_list: "~host_groups_list~",
          hosts_filter: "~hosts_filter~",
          host_groups_filter: "~host_groups_filter~",
          patch_type: "~patch_type~",
          pkgs_to_upgrade: "~pkgs_to_upgrade~",
          pkgs_to_exclude: "~pkgs_to_exclude~",
          pre_patch_script: "~pre_patch_script~",
          patch_script: "~patch_script~",
          post_patch_script: "~post_patch_script~",
          post_patch_reboot_option: "~post_patch_reboot_option~",
          rollout_strategy: "~rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~schedule_type~",
          schedule_time: DateTime.utc_now(),
          last_status: "~last_status~",
          last_run_at: DateTime.utc_now()
        })

      {status, deployment} = DeploymentContext.create_deployment(attr)

      assert status == :ok
      assert deployment.team_id == team.id
      assert deployment.name == "~name~"
      assert deployment.hosts_list == "~hosts_list~"
      assert deployment.host_groups_list == "~host_groups_list~"
      assert deployment.hosts_filter == "~hosts_filter~"
      assert deployment.host_groups_filter == "~host_groups_filter~"
      assert deployment.patch_type == "~patch_type~"
      assert deployment.pkgs_to_upgrade == "~pkgs_to_upgrade~"
      assert deployment.pkgs_to_exclude == "~pkgs_to_exclude~"
      assert deployment.pre_patch_script == "~pre_patch_script~"
      assert deployment.patch_script == "~patch_script~"
      assert deployment.post_patch_script == "~post_patch_script~"
      assert deployment.post_patch_reboot_option == "~post_patch_reboot_option~"
      assert deployment.rollout_strategy == "~rollout_strategy~"
      assert deployment.schedule_type == "~schedule_type~"
      assert deployment.last_status == "~last_status~"
      assert is_binary(deployment.uuid)

      {status, _} =
        DeploymentContext.update_deployment(deployment, %{
          name: "~new_name~",
          hosts_list: "~new_hosts_list~",
          host_groups_list: "~new_host_groups_list~",
          hosts_filter: "~new_hosts_filter~",
          host_groups_filter: "~new_host_groups_filter~",
          patch_type: "~new_patch_type~",
          pkgs_to_upgrade: "~new_pkgs_to_upgrade~",
          pkgs_to_exclude: "~new_pkgs_to_exclude~",
          pre_patch_script: "~new_pre_patch_script~",
          patch_script: "~new_patch_script~",
          post_patch_script: "~new_post_patch_script~",
          post_patch_reboot_option: "~new_post_patch_reboot_option~",
          rollout_strategy: "~new_rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~new_schedule_type~",
          last_status: "~new_status~"
        })

      assert status == :ok

      deployment = DeploymentContext.get_deployment_by_id(deployment.id)

      assert deployment.name == "~new_name~"
      assert deployment.hosts_list == "~new_hosts_list~"
      assert deployment.host_groups_list == "~new_host_groups_list~"
      assert deployment.hosts_filter == "~new_hosts_filter~"
      assert deployment.host_groups_filter == "~new_host_groups_filter~"
      assert deployment.patch_type == "~new_patch_type~"
      assert deployment.pkgs_to_upgrade == "~new_pkgs_to_upgrade~"
      assert deployment.pkgs_to_exclude == "~new_pkgs_to_exclude~"
      assert deployment.pre_patch_script == "~new_pre_patch_script~"
      assert deployment.patch_script == "~new_patch_script~"
      assert deployment.post_patch_script == "~new_post_patch_script~"
      assert deployment.post_patch_reboot_option == "~new_post_patch_reboot_option~"
      assert deployment.rollout_strategy == "~new_rollout_strategy~"
      assert deployment.schedule_type == "~new_schedule_type~"
      assert deployment.status == "~new_status~"
    end
  end

  describe "delete_deployment/1" do
    test "delete_deployment/1 test cases" do
      attrs =
        TeamContext.new_team(%{
          name: "Team 2",
          description: "Description 2"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      attr =
        DeploymentContext.new_deployment(%{
          team_id: team.id,
          name: "~name~",
          hosts_list: "~hosts_list~",
          host_groups_list: "~host_groups_list~",
          hosts_filter: "~hosts_filter~",
          host_groups_filter: "~host_groups_filter~",
          patch_type: "~patch_type~",
          pkgs_to_upgrade: "~pkgs_to_upgrade~",
          pkgs_to_exclude: "~pkgs_to_exclude~",
          pre_patch_script: "~pre_patch_script~",
          patch_script: "~patch_script~",
          post_patch_script: "~post_patch_script~",
          post_patch_reboot_option: "~post_patch_reboot_option~",
          rollout_strategy: "~rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~schedule_type~",
          schedule_time: DateTime.utc_now(),
          last_status: "~last_status~",
          last_run_at: DateTime.utc_now()
        })

      {status, deployment} = DeploymentContext.create_deployment(attr)

      assert status == :ok
      assert deployment.team_id == team.id
      assert deployment.name == "~name~"
      assert deployment.hosts_list == "~hosts_list~"
      assert deployment.host_groups_list == "~host_groups_list~"
      assert deployment.hosts_filter == "~hosts_filter~"
      assert deployment.host_groups_filter == "~host_groups_filter~"
      assert deployment.patch_type == "~patch_type~"
      assert deployment.pkgs_to_upgrade == "~pkgs_to_upgrade~"
      assert deployment.pkgs_to_exclude == "~pkgs_to_exclude~"
      assert deployment.pre_patch_script == "~pre_patch_script~"
      assert deployment.patch_script == "~patch_script~"
      assert deployment.post_patch_script == "~post_patch_script~"
      assert deployment.post_patch_reboot_option == "~post_patch_reboot_option~"
      assert deployment.rollout_strategy == "~rollout_strategy~"
      assert deployment.schedule_type == "~schedule_type~"
      assert deployment.last_status == "~last_status~"
      assert is_binary(deployment.uuid)

      assert DeploymentContext.get_deployment_by_id(deployment.id) == deployment

      DeploymentContext.delete_deployment(deployment)

      assert DeploymentContext.get_deployment_by_id(deployment.id) == nil
    end
  end

  describe "get_deployments/0" do
    test "get_deployments/0 test cases" do
      attrs =
        TeamContext.new_team(%{
          name: "Team 2",
          description: "Description 2"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      attr =
        DeploymentContext.new_deployment(%{
          team_id: team.id,
          name: "~name~",
          hosts_list: "~hosts_list~",
          host_groups_list: "~host_groups_list~",
          hosts_filter: "~hosts_filter~",
          host_groups_filter: "~host_groups_filter~",
          patch_type: "~patch_type~",
          pkgs_to_upgrade: "~pkgs_to_upgrade~",
          pkgs_to_exclude: "~pkgs_to_exclude~",
          pre_patch_script: "~pre_patch_script~",
          patch_script: "~patch_script~",
          post_patch_script: "~post_patch_script~",
          post_patch_reboot_option: "~post_patch_reboot_option~",
          rollout_strategy: "~rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~schedule_type~",
          schedule_time: DateTime.utc_now(),
          last_status: "~last_status~",
          last_run_at: DateTime.utc_now()
        })

      {status, deployment} = DeploymentContext.create_deployment(attr)

      assert status == :ok
      assert deployment.team_id == team.id
      assert deployment.name == "~name~"
      assert deployment.hosts_list == "~hosts_list~"
      assert deployment.host_groups_list == "~host_groups_list~"
      assert deployment.hosts_filter == "~hosts_filter~"
      assert deployment.host_groups_filter == "~host_groups_filter~"
      assert deployment.patch_type == "~patch_type~"
      assert deployment.pkgs_to_upgrade == "~pkgs_to_upgrade~"
      assert deployment.pkgs_to_exclude == "~pkgs_to_exclude~"
      assert deployment.pre_patch_script == "~pre_patch_script~"
      assert deployment.patch_script == "~patch_script~"
      assert deployment.post_patch_script == "~post_patch_script~"
      assert deployment.post_patch_reboot_option == "~post_patch_reboot_option~"
      assert deployment.rollout_strategy == "~rollout_strategy~"
      assert deployment.schedule_type == "~schedule_type~"
      assert deployment.last_status == "~last_status~"
      assert is_binary(deployment.uuid)

      assert DeploymentContext.get_deployments() == [deployment]

      DeploymentContext.delete_deployment(deployment)

      assert DeploymentContext.get_deployments() == []
    end
  end

  describe "get_deployments/2" do
    test "get_deployments/2 test cases" do
      attrs =
        TeamContext.new_team(%{
          name: "Team 2",
          description: "Description 2"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      attr =
        DeploymentContext.new_deployment(%{
          team_id: team.id,
          name: "~name~",
          hosts_list: "~hosts_list~",
          host_groups_list: "~host_groups_list~",
          hosts_filter: "~hosts_filter~",
          host_groups_filter: "~host_groups_filter~",
          patch_type: "~patch_type~",
          pkgs_to_upgrade: "~pkgs_to_upgrade~",
          pkgs_to_exclude: "~pkgs_to_exclude~",
          pre_patch_script: "~pre_patch_script~",
          patch_script: "~patch_script~",
          post_patch_script: "~post_patch_script~",
          post_patch_reboot_option: "~post_patch_reboot_option~",
          rollout_strategy: "~rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~schedule_type~",
          schedule_time: DateTime.utc_now(),
          last_status: "~last_status~",
          last_run_at: DateTime.utc_now()
        })

      {status, deployment} = DeploymentContext.create_deployment(attr)

      assert status == :ok
      assert deployment.team_id == team.id
      assert deployment.name == "~name~"
      assert deployment.hosts_list == "~hosts_list~"
      assert deployment.host_groups_list == "~host_groups_list~"
      assert deployment.hosts_filter == "~hosts_filter~"
      assert deployment.host_groups_filter == "~host_groups_filter~"
      assert deployment.patch_type == "~patch_type~"
      assert deployment.pkgs_to_upgrade == "~pkgs_to_upgrade~"
      assert deployment.pkgs_to_exclude == "~pkgs_to_exclude~"
      assert deployment.pre_patch_script == "~pre_patch_script~"
      assert deployment.patch_script == "~patch_script~"
      assert deployment.post_patch_script == "~post_patch_script~"
      assert deployment.post_patch_reboot_option == "~post_patch_reboot_option~"
      assert deployment.rollout_strategy == "~rollout_strategy~"
      assert deployment.schedule_type == "~schedule_type~"
      assert deployment.last_status == "~last_status~"
      assert is_binary(deployment.uuid)

      assert DeploymentContext.get_deployments(0, 111) == [deployment]
      assert DeploymentContext.get_deployments(1, 111) == []

      DeploymentContext.delete_deployment(deployment)

      assert DeploymentContext.get_deployments(0, 111) == []
    end
  end

  describe "get_deployments_by_team/3" do
    test "get_deployments_by_team/3 test cases" do
      attrs =
        TeamContext.new_team(%{
          name: "Team 2",
          description: "Description 2"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      attr =
        DeploymentContext.new_deployment(%{
          team_id: team.id,
          name: "~name~",
          hosts_list: "~hosts_list~",
          host_groups_list: "~host_groups_list~",
          hosts_filter: "~hosts_filter~",
          host_groups_filter: "~host_groups_filter~",
          patch_type: "~patch_type~",
          pkgs_to_upgrade: "~pkgs_to_upgrade~",
          pkgs_to_exclude: "~pkgs_to_exclude~",
          pre_patch_script: "~pre_patch_script~",
          patch_script: "~patch_script~",
          post_patch_script: "~post_patch_script~",
          post_patch_reboot_option: "~post_patch_reboot_option~",
          rollout_strategy: "~rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~schedule_type~",
          schedule_time: DateTime.utc_now(),
          last_status: "~last_status~",
          last_run_at: DateTime.utc_now()
        })

      {status, deployment} = DeploymentContext.create_deployment(attr)

      assert status == :ok
      assert deployment.team_id == team.id
      assert deployment.name == "~name~"
      assert deployment.hosts_list == "~hosts_list~"
      assert deployment.host_groups_list == "~host_groups_list~"
      assert deployment.hosts_filter == "~hosts_filter~"
      assert deployment.host_groups_filter == "~host_groups_filter~"
      assert deployment.patch_type == "~patch_type~"
      assert deployment.pkgs_to_upgrade == "~pkgs_to_upgrade~"
      assert deployment.pkgs_to_exclude == "~pkgs_to_exclude~"
      assert deployment.pre_patch_script == "~pre_patch_script~"
      assert deployment.patch_script == "~patch_script~"
      assert deployment.post_patch_script == "~post_patch_script~"
      assert deployment.post_patch_reboot_option == "~post_patch_reboot_option~"
      assert deployment.rollout_strategy == "~rollout_strategy~"
      assert deployment.schedule_type == "~schedule_type~"
      assert deployment.last_status == "~last_status~"
      assert is_binary(deployment.uuid)

      assert DeploymentContext.get_deployments_by_team(team.id, 0, 111) == [deployment]
      assert DeploymentContext.get_deployments_by_team(team.id, 1, 111) == []
      assert DeploymentContext.get_deployments_by_team(100, 0, 111) == []

      DeploymentContext.delete_deployment(deployment)

      assert DeploymentContext.get_deployments_by_team(team.id, 0, 111) == []
    end
  end

  describe "create_deployment_meta/1" do
    test "create_deployment_meta/1 test cases" do
      attrs =
        TeamContext.new_team(%{
          name: "Team 2",
          description: "Description 2"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      attr =
        DeploymentContext.new_deployment(%{
          team_id: team.id,
          name: "~name~",
          hosts_list: "~hosts_list~",
          host_groups_list: "~host_groups_list~",
          hosts_filter: "~hosts_filter~",
          host_groups_filter: "~host_groups_filter~",
          patch_type: "~patch_type~",
          pkgs_to_upgrade: "~pkgs_to_upgrade~",
          pkgs_to_exclude: "~pkgs_to_exclude~",
          pre_patch_script: "~pre_patch_script~",
          patch_script: "~patch_script~",
          post_patch_script: "~post_patch_script~",
          post_patch_reboot_option: "~post_patch_reboot_option~",
          rollout_strategy: "~rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~schedule_type~",
          schedule_time: DateTime.utc_now(),
          last_status: "~last_status~",
          last_run_at: DateTime.utc_now()
        })

      {status, deployment} = DeploymentContext.create_deployment(attr)

      assert status == :ok

      meta =
        DeploymentContext.new_meta(%{
          key: "~meta_key~",
          value: "~meta_value~",
          deployment_id: deployment.id
        })

      {status, meta} = DeploymentContext.create_deployment_meta(meta)

      assert status == :ok
      assert meta.deployment_id == deployment.id
      assert meta.key == "~meta_key~"
      assert meta.value == "~meta_value~"
    end
  end

  describe "get_deployment_meta_by_id/1" do
    test "get_deployment_meta_by_id/1 test cases" do
      attrs =
        TeamContext.new_team(%{
          name: "Team 2",
          description: "Description 2"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      attr =
        DeploymentContext.new_deployment(%{
          team_id: team.id,
          name: "~name~",
          hosts_list: "~hosts_list~",
          host_groups_list: "~host_groups_list~",
          hosts_filter: "~hosts_filter~",
          host_groups_filter: "~host_groups_filter~",
          patch_type: "~patch_type~",
          pkgs_to_upgrade: "~pkgs_to_upgrade~",
          pkgs_to_exclude: "~pkgs_to_exclude~",
          pre_patch_script: "~pre_patch_script~",
          patch_script: "~patch_script~",
          post_patch_script: "~post_patch_script~",
          post_patch_reboot_option: "~post_patch_reboot_option~",
          rollout_strategy: "~rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~schedule_type~",
          schedule_time: DateTime.utc_now(),
          last_status: "~last_status~",
          last_run_at: DateTime.utc_now()
        })

      {status, deployment} = DeploymentContext.create_deployment(attr)

      assert status == :ok

      meta =
        DeploymentContext.new_meta(%{
          key: "~meta_key~",
          value: "~meta_value~",
          deployment_id: deployment.id
        })

      {status, meta} = DeploymentContext.create_deployment_meta(meta)

      assert status == :ok
      assert meta.deployment_id == deployment.id
      assert meta.key == "~meta_key~"
      assert meta.value == "~meta_value~"
    end
  end

  describe "update_deployment_meta/2" do
    test "update_deployment_meta/2 test cases" do
      attrs =
        TeamContext.new_team(%{
          name: "Team 2",
          description: "Description 2"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      attr =
        DeploymentContext.new_deployment(%{
          team_id: team.id,
          name: "~name~",
          hosts_list: "~hosts_list~",
          host_groups_list: "~host_groups_list~",
          hosts_filter: "~hosts_filter~",
          host_groups_filter: "~host_groups_filter~",
          patch_type: "~patch_type~",
          pkgs_to_upgrade: "~pkgs_to_upgrade~",
          pkgs_to_exclude: "~pkgs_to_exclude~",
          pre_patch_script: "~pre_patch_script~",
          patch_script: "~patch_script~",
          post_patch_script: "~post_patch_script~",
          post_patch_reboot_option: "~post_patch_reboot_option~",
          rollout_strategy: "~rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~schedule_type~",
          schedule_time: DateTime.utc_now(),
          last_status: "~last_status~",
          last_run_at: DateTime.utc_now()
        })

      {status, deployment} = DeploymentContext.create_deployment(attr)

      assert status == :ok

      meta =
        DeploymentContext.new_meta(%{
          key: "~meta_key~",
          value: "~meta_value~",
          deployment_id: deployment.id
        })

      {status, meta} = DeploymentContext.create_deployment_meta(meta)

      assert status == :ok
      assert meta.deployment_id == deployment.id
      assert meta.key == "~meta_key~"
      assert meta.value == "~meta_value~"

      {status, meta} =
        DeploymentContext.update_deployment_meta(meta, %{
          key: "~new_meta_key~",
          value: "~new_meta_value~"
        })

      assert status == :ok
      assert meta.key == "~new_meta_key~"
      assert meta.value == "~new_meta_value~"
    end
  end

  describe "delete_deployment_meta/1" do
    test "delete_deployment_meta/1 test cases" do
      attrs =
        TeamContext.new_team(%{
          name: "Team 2",
          description: "Description 2"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      attr =
        DeploymentContext.new_deployment(%{
          team_id: team.id,
          name: "~name~",
          hosts_list: "~hosts_list~",
          host_groups_list: "~host_groups_list~",
          hosts_filter: "~hosts_filter~",
          host_groups_filter: "~host_groups_filter~",
          patch_type: "~patch_type~",
          pkgs_to_upgrade: "~pkgs_to_upgrade~",
          pkgs_to_exclude: "~pkgs_to_exclude~",
          pre_patch_script: "~pre_patch_script~",
          patch_script: "~patch_script~",
          post_patch_script: "~post_patch_script~",
          post_patch_reboot_option: "~post_patch_reboot_option~",
          rollout_strategy: "~rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~schedule_type~",
          schedule_time: DateTime.utc_now(),
          last_status: "~last_status~",
          last_run_at: DateTime.utc_now()
        })

      {status, deployment} = DeploymentContext.create_deployment(attr)

      assert status == :ok

      meta =
        DeploymentContext.new_meta(%{
          key: "~meta_key~",
          value: "~meta_value~",
          deployment_id: deployment.id
        })

      {_, meta} = DeploymentContext.create_deployment_meta(meta)

      assert DeploymentContext.get_deployment_meta_by_id_key(deployment.id, "~meta_key~") == meta
      assert DeploymentContext.get_deployment_meta_by_id_key(100_000, "~meta_key~") == nil

      assert DeploymentContext.get_deployment_meta_by_id_key(deployment.id, "~new_meta_key~") ==
               nil

      DeploymentContext.delete_deployment_meta(meta)

      assert DeploymentContext.get_deployment_meta_by_id_key(deployment.id, "~meta_key~") == nil
    end
  end

  describe "get_deployment_meta_by_id_key/2" do
    test "get_deployment_meta_by_id_key/2 test cases" do
      attrs =
        TeamContext.new_team(%{
          name: "Team 2",
          description: "Description 2"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      attr =
        DeploymentContext.new_deployment(%{
          team_id: team.id,
          name: "~name~",
          hosts_list: "~hosts_list~",
          host_groups_list: "~host_groups_list~",
          hosts_filter: "~hosts_filter~",
          host_groups_filter: "~host_groups_filter~",
          patch_type: "~patch_type~",
          pkgs_to_upgrade: "~pkgs_to_upgrade~",
          pkgs_to_exclude: "~pkgs_to_exclude~",
          pre_patch_script: "~pre_patch_script~",
          patch_script: "~patch_script~",
          post_patch_script: "~post_patch_script~",
          post_patch_reboot_option: "~post_patch_reboot_option~",
          rollout_strategy: "~rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~schedule_type~",
          schedule_time: DateTime.utc_now(),
          last_status: "~last_status~",
          last_run_at: DateTime.utc_now()
        })

      {status, deployment} = DeploymentContext.create_deployment(attr)

      assert status == :ok

      meta =
        DeploymentContext.new_meta(%{
          key: "~meta_key~",
          value: "~meta_value~",
          deployment_id: deployment.id
        })

      {_, meta} = DeploymentContext.create_deployment_meta(meta)

      assert DeploymentContext.get_deployment_meta_by_id_key(deployment.id, "~meta_key~") == meta
      assert DeploymentContext.get_deployment_meta_by_id_key(10000, "~meta_key~") == nil

      assert DeploymentContext.get_deployment_meta_by_id_key(deployment.id, "~new_meta_key~") ==
               nil
    end
  end

  describe "get_deployment_metas/1" do
    test "get_deployment_metas/1 test cases" do
      attrs =
        TeamContext.new_team(%{
          name: "Team 2",
          description: "Description 2"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      attr =
        DeploymentContext.new_deployment(%{
          team_id: team.id,
          name: "~name~",
          hosts_list: "~hosts_list~",
          host_groups_list: "~host_groups_list~",
          hosts_filter: "~hosts_filter~",
          host_groups_filter: "~host_groups_filter~",
          patch_type: "~patch_type~",
          pkgs_to_upgrade: "~pkgs_to_upgrade~",
          pkgs_to_exclude: "~pkgs_to_exclude~",
          pre_patch_script: "~pre_patch_script~",
          patch_script: "~patch_script~",
          post_patch_script: "~post_patch_script~",
          post_patch_reboot_option: "~post_patch_reboot_option~",
          rollout_strategy: "~rollout_strategy~",
          rollout_strategy_value: "~rollout_strategy_value~",
          schedule_type: "~schedule_type~",
          schedule_time: DateTime.utc_now(),
          last_status: "~last_status~",
          last_run_at: DateTime.utc_now()
        })

      {status, deployment} = DeploymentContext.create_deployment(attr)

      assert status == :ok

      meta =
        DeploymentContext.new_meta(%{
          key: "~meta_key~",
          value: "~meta_value~",
          deployment_id: deployment.id
        })

      {_, meta} = DeploymentContext.create_deployment_meta(meta)

      assert DeploymentContext.get_deployment_metas(deployment.id) == [meta]
      assert DeploymentContext.get_deployment_metas(100_000) == []
    end
  end
end
