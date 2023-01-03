# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Repo.Migrations.CreateDeployments do
  use Ecto.Migration

  def change do
    create table(:deployments) do
      add :uuid, :uuid
      add :name, :string
      add :hosts_list, :string
      add :host_groups_list, :string
      add :hosts_filter, :string
      add :host_groups_filter, :string
      add :upgrade_type, :string
      add :pkgs_to_upgrade, :string
      add :pkgs_to_exclude, :string
      add :pre_patch_script, :string
      add :post_patch_script, :string
      add :post_patch_reboot_option, :string
      add :rollout_options, :string
      add :schedule_type, :string
      add :status, :string
      add :schedule_time, :utc_datetime
      add :run_at, :utc_datetime
      add :team_id, references(:teams, on_delete: :delete_all)

      timestamps()
    end

    create index(:deployments, [:uuid])
    create index(:deployments, [:team_id])
  end
end
