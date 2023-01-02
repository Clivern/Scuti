# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Model.DeploymentMeta do
  @moduledoc """
  DeploymentMeta Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "deployments_meta" do
    field :key, :string
    field :value, :string
    field :deployment_id, :id

    timestamps()
  end

  @doc false
  def changeset(meta, attrs) do
    meta
    |> cast(attrs, [
      :key,
      :value,
      :deployment_id
    ])
    |> validate_required([
      :key,
      :value,
      :deployment_id
    ])
  end
end
