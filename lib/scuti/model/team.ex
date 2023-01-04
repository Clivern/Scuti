# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Model.Team do
  @moduledoc """
  Team Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :uuid, Ecto.UUID
    field :name, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [
      :uuid,
      :name,
      :description
    ])
    |> validate_required([
      :uuid,
      :name,
      :description
    ])
  end
end
