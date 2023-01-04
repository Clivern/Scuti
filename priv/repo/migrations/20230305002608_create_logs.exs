# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :uuid, :uuid
      add :user_id, references(:users, on_delete: :delete_all)
      add :team_id, references(:teams, on_delete: :delete_all)
      add :host_id, references(:hosts, on_delete: :delete_all)
      add :host_group_id, references(:host_groups, on_delete: :delete_all)
      add :deployment_id, references(:deployments, on_delete: :delete_all)
      add :record, :string

      timestamps()
    end

    create index(:logs, [:uuid])
    create index(:logs, [:user_id])
    create index(:logs, [:team_id])
    create index(:logs, [:host_id])
    create index(:logs, [:host_group_id])
    create index(:logs, [:deployment_id])
  end
end
