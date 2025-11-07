# Copyright 2024 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Module.PermissionModule do
  @moduledoc """
  Permission Module
  """

  alias Scuti.Context.HostGroupContext
  alias Scuti.Context.HostContext
  alias Scuti.Module.TeamModule
  alias Scuti.Module.HostGroupModule
  alias Scuti.Context.DeploymentContext

  def can_access_group_id(:group, :anonymous, _id, _user_id) do
    false
  end

  def can_access_group_id(:group, :super, _id, _user_id) do
    true
  end

  def can_access_group_id(:group, :regular, id, user_id) do
    !!HostGroupContext.get_group_by_id_teams(id, get_user_teams_ids(user_id))
  end

  def can_access_group_uuid(:group, :anonymous, _uuid, _user_id) do
    false
  end

  def can_access_group_uuid(:group, :super, _uuid, _user_id) do
    true
  end

  def can_access_group_uuid(:group, :regular, uuid, user_id) do
    !!HostGroupContext.get_group_by_uuid_teams(uuid, get_user_teams_ids(user_id))
  end

  def can_access_deployment_id(:deployment, :anonymous, _id, _user_id) do
    false
  end

  def can_access_deployment_id(:deployment, :super, _id, _user_id) do
    true
  end

  def can_access_deployment_id(:deployment, :regular, id, user_id) do
    !!DeploymentContext.get_deployment_by_id_teams(id, get_user_teams_ids(user_id))
  end

  def can_access_deployment_uuid(:deployment, :anonymous, _uuid, _user_id) do
    false
  end

  def can_access_deployment_uuid(:deployment, :super, _uuid, _user_id) do
    true
  end

  def can_access_deployment_uuid(:deployment, :regular, uuid, user_id) do
    !!DeploymentContext.get_deployment_by_uuid_teams(uuid, get_user_teams_ids(user_id))
  end

  def can_access_host_id(:host, :anonymous, _id, _user_id) do
    false
  end

  def can_access_host_id(:host, :super, _id, _user_id) do
    true
  end

  def can_access_host_id(:host, :regular, id, user_id) do
    !!HostContext.get_host_by_id_groups(id, get_user_group_ids(user_id))
  end

  def can_access_host_uuid(:host, :anonymous, _uuid, _user_id) do
    false
  end

  def can_access_host_uuid(:host, :super, _uuid, _user_id) do
    true
  end

  def can_access_host_uuid(:host, :regular, uuid, user_id) do
    !!HostContext.get_host_by_uuid_groups(uuid, get_user_group_ids(user_id))
  end

  defp get_user_teams_ids(user_id) do
    user_teams = TeamModule.get_user_teams(user_id)

    teams_ids = []

    teams_ids =
      for user_team <- user_teams do
        teams_ids ++ user_team.id
      end

    teams_ids
  end

  defp get_user_group_ids(user_id) do
    groups =
      get_user_teams_ids(user_id)
      |> HostGroupModule.get_groups_by_teams()

    groups_ids = []

    groups_ids =
      for group <- groups do
        groups_ids ++ group.id
      end

    groups_ids
  end
end
