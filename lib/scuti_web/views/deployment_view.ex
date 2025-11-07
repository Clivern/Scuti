# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.DeploymentView do
  use ScutiWeb, :view

  alias Scuti.Module.TeamModule

  # Render deployments list
  def render("list.json", %{deployments: deployments, metadata: metadata}) do
    %{
      deployments: Enum.map(deployments, &render_deployment/1),
      _metadata: %{
        limit: metadata.limit,
        offset: metadata.offset,
        totalCount: metadata.totalCount
      }
    }
  end

  # Render deployment
  def render("index.json", %{deployment: deployment}) do
    render_deployment(deployment)
  end

  # Render errors
  def render("error.json", %{message: message}) do
    %{errorMessage: message}
  end

  # Format deployment
  defp render_deployment(deployment) do
    {_, team} = TeamModule.get_team_by_id(deployment.team_id)

    %{
      id: deployment.uuid,
      name: deployment.name,
      description: deployment.description,
      team: %{
        id: team.uuid,
        name: team.name
      },
      hostsFilter: deployment.hosts_filter,
      hostGroupsFilter: deployment.host_groups_filter,
      patchType: deployment.patch_type,
      prePatchScript: deployment.pre_patch_script,
      patchScript: deployment.patch_script,
      postPatchScript: deployment.post_patch_script,
      postPatchRebootOption: deployment.post_patch_reboot_option,
      rolloutStrategy: deployment.rollout_strategy,
      rolloutStrategyValue: deployment.rollout_strategy_value,
      scheduleType: deployment.schedule_type,
      scheduleTime: deployment.schedule_time,
      lastStatus: deployment.last_status,
      lastRunAt: deployment.last_run_at,
      createdAt: deployment.inserted_at,
      updatedAt: deployment.updated_at
    }
  end
end
