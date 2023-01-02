# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Model.Log do
  @moduledoc """
  Log Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :uuid, Ecto.UUID
    field :user_id, :id
    field :team_id, :id
    field :host_id, :id
    field :host_group_id, :id
    field :deployment_id, :id
    field :record, :string

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [
      :uuid,
      :user_id,
      :team_id,
      :host_id,
      :host_group_id,
      :deployment_id,
      :record
    ])
    |> validate_required([
      :uuid,
      :record
    ])
  end
end
