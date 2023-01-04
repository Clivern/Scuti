# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Model.LogMeta do
  @moduledoc """
  LogMeta Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "logs_meta" do
    field :key, :string
    field :value, :string
    field :log_id, :id

    timestamps()
  end

  @doc false
  def changeset(meta, attrs) do
    meta
    |> cast(attrs, [
      :key,
      :value,
      :log_id
    ])
    |> validate_required([
      :key,
      :value,
      :log_id
    ])
  end
end
