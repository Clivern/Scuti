# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.HostGroupView do
  use ScutiWeb, :view

  alias Scuti.Module.TeamModule
  alias Scuti.Context.HostContext

  # Render groups list
  def render("list.json", %{groups: groups, metadata: metadata}) do
    %{
      groups: Enum.map(groups, &render_group/1),
      _metadata: %{
        limit: metadata.limit,
        offset: metadata.offset,
        totalCount: metadata.totalCount
      }
    }
  end

  # Render group
  def render("index.json", %{group: group}) do
    render_group(group)
  end

  # Render errors
  def render("error.json", %{message: message}) do
    %{errorMessage: message}
  end

  # Format group
  defp render_group(group) do
    {_, team} = TeamModule.get_team_by_id(group.team_id)

    %{
      id: group.uuid,
      name: group.name,
      description: group.description,
      team: %{
        id: team.uuid,
        name: team.name
      },
      labels: group.labels,
      secretKey: group.secret_key,
      remoteJoin: group.remote_join,
      hostsCount: HostContext.count_hosts_by_host_group(group.id),
      createdAt: group.inserted_at,
      updatedAt: group.updated_at
    }
  end
end
