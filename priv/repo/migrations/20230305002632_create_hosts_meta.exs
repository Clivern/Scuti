# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Repo.Migrations.CreateHostsMeta do
  use Ecto.Migration

  def change do
    create table(:hosts_meta) do
      add :key, :string
      add :value, :text
      add :host_id, references(:hosts, on_delete: :delete_all)

      timestamps()
    end

    create index(:hosts_meta, [:key])
    create index(:hosts_meta, [:host_id])
  end
end
