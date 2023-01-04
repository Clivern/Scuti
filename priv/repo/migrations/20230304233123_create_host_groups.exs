# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Repo.Migrations.CreateHostGroups do
  use Ecto.Migration

  def change do
    create table(:host_groups) do
      add :uuid, :uuid
      add :name, :string
      add :description, :string
      add :team_id, references(:teams, on_delete: :delete_all)

      timestamps()
    end

    create index(:host_groups, [:uuid])
  end
end
