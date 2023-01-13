# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.HostGroupView do
  use ScutiWeb, :view

  def render("error.json", %{message: message}) do
    %{errorMessage: message}
  end

  def render("success.json", %{message: message}) do
    %{successMessage: message}
  end

  def render("create.json", %{group: group}) do
    %{
      id: group.id,
      uuid: group.uuid,
      teamId: group.team_id,
      name: group.name,
      apiKey: group.api_key,
      labels: group.labels,
      remoteJoin: group.remote_join,
      createdAt: group.inserted_at,
      updatedAt: group.updated_at
    }
  end

  def render("index.json", %{group: group}) do
    %{
      id: group.id,
      uuid: group.uuid,
      teamId: group.team_id,
      name: group.name,
      apiKey: group.api_key,
      labels: group.labels,
      remoteJoin: group.remote_join,
      createdAt: group.inserted_at,
      updatedAt: group.updated_at
    }
  end
end
