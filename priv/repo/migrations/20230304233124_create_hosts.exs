# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Repo.Migrations.CreateHosts do
  use Ecto.Migration

  def change do
    create table(:hosts) do
      add :uuid, :uuid
      add :name, :string
      add :hostname, :string
      add :private_ips, :string
      add :public_ips, :string
      add :labels, :string
      add :status, :string
      add :team_id, references(:teams, on_delete: :delete_all)
      add :host_group_id, references(:host_groups, on_delete: :delete_all)
      add :reported_at, :utc_datetime

      timestamps()
    end

    create index(:hosts, [:uuid])
    create index(:hosts, [:team_id])
    create index(:hosts, [:host_group_id])
  end
end
