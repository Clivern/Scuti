# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.ConfigContext do
  @moduledoc """
  Config Context Module

  Manages configuration settings, providing functions for CRUD operations.
  """

  import Ecto.Query

  alias Scuti.Repo
  alias Scuti.Model.Config

  @doc """
  Initializes a new config with given attributes.
  Generates a UUID if not provided.
  """
  def new_config(attrs \\ %{}) do
    %{
      name: attrs.name,
      value: attrs.value,
      uuid: Map.get(attrs, :uuid, Ecto.UUID.generate())
    }
  end

  @doc """
  Creates and saves a new config to the database.
  """
  def create_config(attrs \\ %{}) do
    %Config{}
    |> Config.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieves a config by its ID.
  """
  def get_config_by_id(id) do
    Repo.get(Config, id)
  end

  @doc """
  Retrieves a config by its UUID.
  """
  def get_config_by_uuid(uuid) do
    from(
      c in Config,
      where: c.uuid == ^uuid
    )
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Retrieves a config by its name.
  """
  def get_config_by_name(name) do
    from(
      c in Config,
      where: c.name == ^name
    )
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Updates an existing config with new attributes.
  """
  def update_config(config, attrs) do
    config
    |> Config.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a specified config from the database.
  """
  def delete_config(config) do
    Repo.delete(config)
  end
end
