# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Repo.Migrations.CreateHostGroups do
  use Ecto.Migration

  def change do
    create table(:host_groups) do
      add :uuid, :uuid
      add :name, :string
      add :api_key, :string
      add :labels, :string
      add :remote_join, :boolean, default: false
      add :team_id, references(:teams, on_delete: :delete_all)

      timestamps()
    end

    create index(:host_groups, [:uuid])
    create index(:host_groups, [:team_id])
    create index(:host_groups, [:api_key])
  end
end
