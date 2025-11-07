# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Module.SettingsModule do
  @moduledoc """
  Settings Module
  """

  alias Scuti.Context.ConfigContext

  @doc """
  Update Application Configs
  """
  def update_configs(configs \\ %{}) do
    items = [
      ConfigContext.new_config(%{name: "app_name", value: configs[:app_name]}),
      ConfigContext.new_config(%{name: "app_url", value: configs[:app_url]}),
      ConfigContext.new_config(%{name: "app_email", value: configs[:app_email]})
    ]

    for item <- items do
      config = ConfigContext.get_config_by_name(item.name)
      ConfigContext.update_config(config, %{value: item.value})
    end
  end

  @doc """
  Get Config By Name
  """
  def get_config(name, default \\ "") do
    (ConfigContext.get_config_by_name(name) || %{value: default}).value
  end
end
