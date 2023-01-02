# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Model.HostGroupMeta do
  @moduledoc """
  HostGroupMeta Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "host_groups_meta" do
    field :key, :string
    field :value, :string
    field :host_group_id, :id

    timestamps()
  end

  @doc false
  def changeset(meta, attrs) do
    meta
    |> cast(attrs, [
      :key,
      :value,
      :host_group_id
    ])
    |> validate_required([
      :key,
      :value,
      :host_group_id
    ])
  end
end
