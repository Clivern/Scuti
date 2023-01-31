# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Repo.Migrations.CreateTasksLog do
  use Ecto.Migration

  def change do
    create table(:tasks_log) do
      add :uuid, :uuid
      add :host_id, references(:hosts, on_delete: :delete_all)
      add :task_id, references(:tasks, on_delete: :delete_all)
      add :type, :string
      add :record, :string

      timestamps()
    end

    create index(:tasks_log, [:uuid])
    create index(:tasks_log, [:host_id])
    create index(:tasks_log, [:task_id])
  end
end
