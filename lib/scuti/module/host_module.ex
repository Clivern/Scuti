# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Module.HostModule do
  @moduledoc """
  Host Module
  """

  alias Scuti.Context.HostContext
  alias Scuti.Context.HostGroupContext

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
        status: "offline",
        reported_at: DateTime.utc_now(),
        secret_key: data[:secret_key]
      })

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
  Update a host
  """
  def update_host(data \\ %{}) do
    case HostContext.get_host_by_uuid(data[:uuid]) do
      nil ->
        {:not_found, "Host with ID #{data[:uuid]} not found"}

      host ->
        new_host = %{
          name: data[:name] || host.name,
          hostname: data[:hostname] || host.hostname,
          agent_address: data[:agent_address] || host.agent_address,
          labels: data[:labels] || host.labels,
          secret_key: data[:secret_key] || host.secret_key
        }

        case HostContext.update_host(host, new_host) do
          {:ok, host} ->
            {:ok, host}

          {:error, changeset} ->
            messages =
              changeset.errors()
              |> Enum.map(fn {field, {message, _options}} -> "#{field}: #{message}" end)

            {:error, Enum.at(messages, 0)}
        end
    end
  end

  @doc """
  Mark host as up
  """
  def mark_host_as_online(id) do
    host = HostContext.get_host_by_id(id)

    case host do
      nil ->
        {:not_found, "Host with ID #{id} not found"}

      _ ->
        new_host = %{
          status: "online",
          reported_at: DateTime.utc_now()
        }

        case HostContext.update_host(host, new_host) do
          {:ok, host} ->
            {:ok, host}

          {:error, changeset} ->
            messages =
              changeset.errors()
              |> Enum.map(fn {field, {message, _options}} -> "#{field}: #{message}" end)

            {:error, Enum.at(messages, 0)}
        end
    end
  end

  @doc """
  Get host group hosts
  """
  def get_hosts(group_uuid, offset, limit) do
    case HostGroupContext.get_group_id_with_uuid(group_uuid) do
      nil ->
        []

      group_id ->
        HostContext.get_hosts_by_host_group(group_id, offset, limit)
    end
  end

  @doc """
  Count host group hosts
  """
  def count_hosts(group_uuid) do
    case HostGroupContext.get_group_id_with_uuid(group_uuid) do
      nil ->
        0

      group_id ->
        HostContext.count_hosts_by_host_group(group_id)
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
    case HostContext.get_host_by_uuid(uuid) do
      nil ->
        {:not_found, "Host with ID #{uuid} not found"}

      host ->
        {:ok, host}
    end
  end

  @doc """
  Get host as offline if x seconds has passed and agent didn't send any
  heartbeat
  """
  def mark_hosts_as_offline(seconds) do
    HostContext.mark_hosts_as_offline(seconds)
  end

  @doc """
  Delete a host by UUID
  """
  def delete_host_by_uuid(uuid) do
    case HostContext.get_host_by_uuid(uuid) do
      nil ->
        {:not_found, "Host with ID #{uuid} not found"}

      host ->
        HostContext.delete_host(host)
        {:ok, "Host with ID #{uuid} deleted successfully"}
    end
  end
end
