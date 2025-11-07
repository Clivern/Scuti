# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Model.Lock do
  @moduledoc """
  Lock Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "locks" do
    field :uuid, Ecto.UUID
    field :key, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(config, attrs) do
    config
    |> cast(attrs, [
      :uuid,
      :key,
      :status
    ])
    |> validate_required([
      :uuid,
      :key,
      :status
    ])
  end
end
