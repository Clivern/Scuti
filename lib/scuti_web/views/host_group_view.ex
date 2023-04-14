# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.HostGroupView do
  use ScutiWeb, :view

  alias Scuti.Module.TeamModule

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
    %{
      id: group.uuid,
      teamId: TeamModule.get_team_uuid_with_id(group.team_id),
      name: group.name,
      apiKey: group.secret_key,
      labels: group.labels,
      remoteJoin: group.remote_join,
      createdAt: group.inserted_at,
      updatedAt: group.updated_at
    }
  end
end
