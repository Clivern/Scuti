# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Module.HostModule do
  @moduledoc """
  Host Module
  """

  alias Scuti.Context.HostContext

  def get_hosts_by_group(group_id, offset, limit) do
    HostContext.get_hosts_by_host_group(group_id, offset, limit)
  end
end
