# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :uuid, :uuid
      add :payload, :string
      add :result, :string
      add :status, :string
      add :deployment_id, references(:deployments, on_delete: :delete_all)

      timestamps()
    end

    create index(:tasks, [:deployment_id])
  end
end
