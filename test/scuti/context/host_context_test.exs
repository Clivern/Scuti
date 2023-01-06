# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.HostContextTest do
  @moduledoc """
  Host Context Test Cases
  """
  use ExUnit.Case

  alias Scuti.Context.HostContext
  alias Scuti.Context.HostGroupContext

  # Init
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Scuti.Repo)
  end

  # Test Cases
  describe "new_host/1" do
    test "new_host/1 test cases" do
      host =
        HostContext.new_host(%{
          name: "~name~",
          hostname: "~hostname~",
          labels: "~labels~",
          private_ips: "~private_ips~",
          public_ips: "~public_ips~",
          status: "~status~",
          reported_at: "~reported_at~",
          host_group_id: 2
        })

      assert host.host_group_id == 2
      assert host.name == "~name~"
      assert host.hostname == "~hostname~"
      assert host.labels == "~labels~"
      assert host.private_ips == "~private_ips~"
      assert host.public_ips == "~public_ips~"
      assert host.status == "~status~"
      assert host.reported_at == "~reported_at~"
    end
  end

  describe "new_meta/1" do
    test "test new_meta" do
      meta =
        HostContext.new_meta(%{
          key: "meta_key",
          value: "meta_value",
          host_id: 1
        })

      assert meta.host_id == 1
      assert meta.key == "meta_key"
      assert meta.value == "meta_value"
    end
  end
end
