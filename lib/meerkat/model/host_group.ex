# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Model.HostGroup do
  @moduledoc """
  HostGroup Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "host_groups" do
    field :uuid, Ecto.UUID
    field :team_id, :id
    field :name, :string
    field :api_key, :string
    field :labels, :string

    timestamps()
  end

  @doc false
  def changeset(lock, attrs) do
    lock
    |> cast(attrs, [
      :uuid,
      :team_id,
      :name,
      :api_key,
      :labels
    ])
    |> validate_required([
      :uuid,
      :team_id,
      :name,
      :api_key,
      :labels
    ])
  end
end