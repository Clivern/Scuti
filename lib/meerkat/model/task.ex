# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Model.Task do
  @moduledoc """
  Task Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :uuid, Ecto.UUID
    field :deployment_id, :id
    field :payload, :string
    field :result, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(meta, attrs) do
    meta
    |> cast(attrs, [
      :uuid,
      :deployment_id,
      :payload,
      :result,
      :status
    ])
    |> validate_required([
      :uuid,
      :deployment_id,
      :payload,
      :result,
      :status
    ])
  end
end
