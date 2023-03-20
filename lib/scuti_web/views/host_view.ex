# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.HostView do
  use ScutiWeb, :view

  alias Scuti.Module.HostGroupModule

  # Render hosts list
  def render("list.json", %{hosts: hosts, metadata: metadata}) do
    %{
      hosts: Enum.map(hosts, &render_host/1),
      _metadata: %{
        limit: metadata.limit,
        offset: metadata.offset,
        totalCount: metadata.totalCount
      }
    }
  end

  # Render host
  def render("index.json", %{host: host}) do
    render_host(host)
  end

  # Render errors
  def render("error.json", %{message: message}) do
    %{errorMessage: message}
  end

  # Format host
  defp render_host(host) do
    group = HostGroupModule.get_group_by_id(host.host_group_id)

    %{
      id: host.uuid,
      name: host.name,
      hostname: host.hostname,
      group: %{
        id: group.uuid,
        name: group.name,
        description: group.description,
        secretKey: group.secret_key,
        remoteJoin: group.remote_join,
        labels: group.labels
      },
      labels: host.labels,
      agentAddress: host.agent_address,
      status: host.status,
      secretKey: host.secret_key,
      createdAt: host.inserted_at,
      updatedAt: host.updated_at,
      reportedAt: host.reported_at
    }
  end
end
