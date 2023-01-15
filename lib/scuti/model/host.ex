# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Model.Host do
  @moduledoc """
  Host Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "hosts" do
    field :uuid, Ecto.UUID
    field :host_group_id, :id
    field :name, :string
    field :hostname, :string
    field :private_ips, :string
    field :public_ips, :string
    field :labels, :string
    field :status, :string
    field :secret_key, :string
    field :reported_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(host, attrs) do
    host
    |> cast(attrs, [
      :uuid,
      :host_group_id,
      :name,
      :hostname,
      :private_ips,
      :public_ips,
      :labels,
      :status,
      :secret_key,
      :reported_at
    ])
    |> validate_required([
      :uuid,
      :host_group_id,
      :name,
      :hostname,
      :private_ips,
      :public_ips,
      :labels,
      :status,
      :secret_key,
      :reported_at
    ])
  end
end
