# Copyright 2024 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Module.PermissionModule do
  @moduledoc """
  Permission Module
  """

  alias Scuti.Context.HostGroupContext
  alias Scuti.Module.TeamModule

  def can_access_group_id(:group, :anonymous, _id, _user_id) do
    false
  end

  def can_access_group_id(:group, :super, _id, _user_id) do
    true
  end

  def can_access_group_id(:group, :regular, id, user_id) do
    case HostGroupContext.get_group_by_id_teams(id, get_user_teams_ids(user_id)) do
      nil ->
        false

      _ ->
        true
    end
  end

  def can_access_group_uuid(:group, :anonymous, _uuid, _user_id) do
    false
  end

  def can_access_group_uuid(:group, :super, _uuid, _user_id) do
    true
  end

  def can_access_group_uuid(:group, :regular, uuid, user_id) do
    case HostGroupContext.get_group_by_uuid_teams(uuid, get_user_teams_ids(user_id)) do
      nil ->
        false

      _ ->
        true
    end
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
end
