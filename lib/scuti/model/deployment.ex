# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Model.Deployment do
  @moduledoc """
  Deployment Model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "deployments" do
    field :uuid, Ecto.UUID
    field :team_id, :id
    field :name, :string
    field :hosts_list, :string
    field :host_groups_list, :string
    field :hosts_filter, :string
    field :host_groups_filter, :string
    # :upgrade || :dist_upgrade || :custom_patch
    field :patch_type, :string
    # ONLY IF patch_type IS :upgrade
    field :pkgs_to_upgrade, :string
    # ONLY IF patch_type IS :upgrade
    field :pkgs_to_exclude, :string
    field :pre_patch_script, :string
    field :patch_script, :string
    field :post_patch_script, :string
    # :always || :only_if_needed
    field :post_patch_reboot_option, :string
    # :one_by_one || :all_at_once || :percent || :count
    field :rollout_strategy, :string
    # 10% || 20
    field :rollout_strategy_value, :string
    # :once || :recursive
    field :schedule_type, :string
    field :schedule_time, :utc_datetime
    # :pending || :running || :success || :failure
    field :last_status, :string
    field :last_run_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(deployment, attrs) do
    deployment
    |> cast(attrs, [
      :uuid,
      :team_id,
      :name,
      :hosts_list,
      :host_groups_list,
      :hosts_filter,
      :host_groups_filter,
      :patch_type,
      :pkgs_to_upgrade,
      :pkgs_to_exclude,
      :pre_patch_script,
      :patch_script,
      :post_patch_script,
      :post_patch_reboot_option,
      :rollout_strategy,
      :rollout_strategy_value,
      :schedule_type,
      :schedule_time,
      :last_status,
      :last_run_at
    ])
    |> validate_required([
      :uuid,
      :team_id,
      :name,
      :hosts_list,
      :host_groups_list,
      :hosts_filter,
      :host_groups_filter,
      :patch_type,
      :pkgs_to_upgrade,
      :pkgs_to_exclude,
      :pre_patch_script,
      :patch_script,
      :post_patch_script,
      :post_patch_reboot_option,
      :rollout_strategy,
      :rollout_strategy_value,
      :schedule_type,
      :schedule_time,
      :last_status,
      :last_run_at
    ])
  end
end
