# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Repo.Migrations.CreateTasksMeta do
  use Ecto.Migration

  def change do
    create table(:tasks_meta) do
      add :key, :string
      add :value, :text
      add :task_id, references(:tasks, on_delete: :delete_all)

      timestamps()
    end

    create index(:projects_meta, [:key])
    create index(:projects_meta, [:task_id])
  end
end