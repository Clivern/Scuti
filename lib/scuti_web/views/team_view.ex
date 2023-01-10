# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.TeamView do
  use ScutiWeb, :view

  def render("error.json", %{message: message}) do
    %{errorMessage: message}
  end

  def render("success.json", %{message: message}) do
    %{successMessage: message}
  end

  def render("create.json", %{team: team}) do
    %{
      id: team.id,
      uuid: team.uuid,
      name: team.name,
      description: team.description,
      createdAt: team.inserted_at,
      updatedAt: team.updated_at
    }
  end

  def render("index.json", %{team: team}) do
    %{
      id: team.id,
      uuid: team.uuid,
      name: team.name,
      description: team.description,
      createdAt: team.inserted_at,
      updatedAt: team.updated_at
    }
  end
end
