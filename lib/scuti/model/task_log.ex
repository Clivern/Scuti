# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Model.TaskLog do
  @moduledoc """
  Task Log Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks_log" do
    field :uuid, Ecto.UUID
    field :host_id, :id
    field :task_id, :id
    field :type, :string
    field :record, :string

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [
      :uuid,
      :host_id,
      :task_id,
      :type,
      :record
    ])
    |> validate_required([
      :uuid,
      :host_id,
      :task_id,
      :type,
      :record
    ])
  end
end
