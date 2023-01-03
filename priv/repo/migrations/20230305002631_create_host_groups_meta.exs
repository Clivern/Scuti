# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Repo.Migrations.CreateHostGroupsMeta do
  use Ecto.Migration

  def change do
    create table(:host_groups_meta) do
      add :key, :string
      add :value, :text
      add :host_group_id, references(:host_groups, on_delete: :delete_all)

      timestamps()
    end

    create index(:host_groups_meta, [:key])
    create index(:host_groups_meta, [:host_group_id])
  end
end
