# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Module.HostModule do
  @moduledoc """
  Host Module
  """

  alias Scuti.Context.HostContext

  @doc """
  Create a host
  """
  def create_host(data \\ %{}) do
    host =
      HostContext.new_host(%{
        name: data[:name],
        hostname: data[:hostname],
        host_group_id: data[:host_group_id],
        labels: data[:labels],
        agent_address: data[:agent_address],
        status: data[:status],
        reported_at: data[:reported_at],
        secret_key: data[:secret_key]
      })

    host =
      if data[:uuid] != nil do
        %{host | uuid: data[:uuid]}
      end

    case HostContext.create_host(host) do
      {:ok, host} ->
        {:ok, host}

      {:error, changeset} ->
        messages =
          changeset.errors()
          |> Enum.map(fn {field, {message, _options}} -> "#{field}: #{message}" end)

        {:error, Enum.at(messages, 0)}
    end
  end

  @doc """
  Get hosts by a group
  """
  def get_hosts_by_group(group_id, offset, limit) do
    HostContext.get_hosts_by_host_group(group_id, offset, limit)
  end

  @doc """
  Get a host by UUID
  """
  def get_host_by_uuid(uuid) do
    HostContext.get_host_by_uuid(uuid)
  end
end
