# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Model.Deployment do
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
    field :upgrade_type, :string
    field :pkgs_to_upgrade, :string
    field :pkgs_to_exclude, :string
    field :pre_patch_script, :string
    field :post_patch_script, :string
    field :post_patch_reboot_option, :string
    field :rollout_options, :string
    field :schedule_type, :string
    field :schedule_time, :utc_datetime
    field :status, :string
    field :run_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(state, attrs) do
    state
    |> cast(attrs, [
      :uuid,
      :team_id,
      :user_id,
      :name,
      :hosts_list,
      :host_groups_list,
      :hosts_filter,
      :host_groups_filter,
      :upgrade_type,
      :pkgs_to_upgrade,
      :pkgs_to_exclude,
      :pre_patch_script,
      :post_patch_script,
      :post_patch_reboot_option,
      :rollout_options,
      :schedule_type,
      :schedule_time,
      :status,
      :run_at
    ])
    |> validate_required([
      :uuid,
      :team_id,
      :name,
      :hosts_list,
      :host_groups_list,
      :hosts_filter,
      :host_groups_filter,
      :upgrade_type,
      :pkgs_to_upgrade,
      :pkgs_to_exclude,
      :pre_patch_script,
      :post_patch_script,
      :post_patch_reboot_option,
      :rollout_options,
      :schedule_type,
      :schedule_time,
      :status,
      :run_at
    ])
  end
end
