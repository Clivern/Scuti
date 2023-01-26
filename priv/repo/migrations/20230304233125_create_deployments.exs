# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Repo.Migrations.CreateDeployments do
  use Ecto.Migration

  def change do
    create table(:deployments) do
      add :uuid, :uuid
      add :name, :string

      add :hosts_filter, :string
      add :host_groups_filter, :string

      add :patch_type, :string
      add :pkgs_to_upgrade, :string
      add :pkgs_to_exclude, :string

      add :pre_patch_script, :string
      add :patch_script, :string
      add :post_patch_script, :string
      add :post_patch_reboot_option, :string

      add :rollout_strategy, :string
      add :rollout_strategy_value, :string

      add :schedule_type, :string
      add :schedule_time, :utc_datetime

      add :last_status, :string
      add :last_run_at, :utc_datetime
      add :team_id, references(:teams, on_delete: :delete_all)

      timestamps()
    end

    create index(:deployments, [:uuid])
    create index(:deployments, [:team_id])
  end
end
