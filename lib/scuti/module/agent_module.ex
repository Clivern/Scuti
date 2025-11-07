# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Module.AgentModule do
  @moduledoc """
  Agent Module
  """

  @doc """
  New agent register request
  """
  def register_request(_data \\ %{}) do
  end

  @doc """
  New agent heartbeat request
  """
  def heartbeat_request(_data \\ %{}) do
  end

  defp encode(%{
         name: name,
         hostname: hostname,
         agent_address: agent_address,
         labels: labels,
         agent_secret: agent_secret
       }) do
    ~c"{\"name\":\"#{name}\",\"hostname\":\"#{hostname}\",\"agent_address\":\"#{agent_address}\",\"labels\":\"#{labels}\",\"agent_secret\":\"#{agent_secret}\"}"
  end

  defp encode(%{status: status}) do
    ~c"{\"status\":\"#{status}\"}"
  end

  defp encode(%{type: type, record: record}) do
    ~c"{\"type\":\"#{type}\",\"record\":\"#{record}\"}"
  end

  defp fetch(map, key, default \\ "") do
    case Map.fetch(map, key) do
      :error -> default
      {:ok, value} -> value
    end
  end
end
