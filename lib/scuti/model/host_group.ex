# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Model.HostGroup do
  @moduledoc """
  HostGroup Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "host_groups" do
    field :uuid, Ecto.UUID
    field :team_id, :id
    field :name, :string
    field :secret_key, :string
    field :labels, :string
    field :remote_join, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(host_group, attrs) do
    host_group
    |> cast(attrs, [
      :uuid,
      :team_id,
      :name,
      :secret_key,
      :labels,
      :remote_join
    ])
    |> validate_required([
      :uuid,
      :team_id,
      :name,
      :secret_key,
      :labels,
      :remote_join
    ])
  end
end
