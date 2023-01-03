# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Repo.Migrations.CreateDeploymentsMeta do
  use Ecto.Migration

  def change do
    create table(:deployments_meta) do
      add :key, :string
      add :value, :text
      add :deployment_id, references(:deployments, on_delete: :delete_all)

      timestamps()
    end

    create index(:deployments_meta, [:key])
    create index(:deployments_meta, [:deployment_id])
  end
end
