# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :uuid, :uuid
      add :name, :string
      add :description, :string

      timestamps()
    end

    create index(:teams, [:uuid])
  end
end
