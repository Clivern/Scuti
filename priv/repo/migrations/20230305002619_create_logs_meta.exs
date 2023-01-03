# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Repo.Migrations.CreateLogsMeta do
  use Ecto.Migration

  def change do
    create table(:logs_meta) do
      add :key, :string
      add :value, :text
      add :log_id, references(:logs, on_delete: :delete_all)

      timestamps()
    end

    create index(:logs_meta, [:key])
    create index(:logs_meta, [:log_id])
  end
end
