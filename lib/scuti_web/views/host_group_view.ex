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

  def render("create.json", %{user: user}) do
    %{
      id: user.id,
      uuid: user.uuid,
      name: user.name,
      email: user.email,
      role: user.role,
      apiKey: user.api_key,
      createdAt: user.inserted_at,
      updatedAt: user.updated_at
    }
  end

  def render("index.json", %{user: user}) do
    %{
      id: user.id,
      uuid: user.uuid,
      name: user.name,
      email: user.email,
      role: user.role,
      apiKey: user.api_key,
      createdAt: user.inserted_at,
      updatedAt: user.updated_at
    }
  end
end
