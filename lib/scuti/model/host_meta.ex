# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Model.HostMeta do
  @moduledoc """
  HostMeta Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "hosts_meta" do
    field :key, :string
    field :value, :string
    field :host_id, :id

    timestamps()
  end

  @doc false
  def changeset(meta, attrs) do
    meta
    |> cast(attrs, [
      :key,
      :value,
      :host_id
    ])
    |> validate_required([
      :key,
      :value,
      :host_id
    ])
  end
end
