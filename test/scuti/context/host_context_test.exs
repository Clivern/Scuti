# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.HostContextTest do
  @moduledoc """
  Host Context Test Cases
  """
  use ExUnit.Case

  alias Scuti.Context.TeamContext
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
          key: "~meta_key~",
          value: "~meta_value~",
          host_id: 1
        })

      assert meta.host_id == 1
      assert meta.key == "~meta_key~"
      assert meta.value == "~meta_value~"
    end
  end

  describe "create_host/1" do
    test "test create_host" do
      attrs =
        TeamContext.new_team(%{
          name: "team_a",
          description: "team_a"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      group =
        HostGroupContext.new_group(%{
          name: "group_name",
          api_key: "group_api_key",
          team_id: team.id,
          labels: "name=infra"
        })

      {_, group} = HostGroupContext.create_group(group)

      host =
        HostContext.new_host(%{
          name: "~name~",
          hostname: "~hostname~",
          labels: "~labels~",
          private_ips: "~private_ips~",
          public_ips: "~public_ips~",
          status: "~status~",
          reported_at: DateTime.utc_now(),
          host_group_id: group.id
        })

      {_, host} = HostContext.create_host(host)

      assert host.name == "~name~"
      assert host.hostname == "~hostname~"
      assert host.labels == "~labels~"
      assert host.private_ips == "~private_ips~"
      assert host.public_ips == "~public_ips~"
      assert host.status == "~status~"
      assert host.host_group_id == group.id
    end
  end

  describe "get_host_by_id/1" do
    test "test get_host_by_id" do
      attrs =
        TeamContext.new_team(%{
          name: "team_a",
          description: "team_a"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      group =
        HostGroupContext.new_group(%{
          name: "group_name",
          api_key: "group_api_key",
          team_id: team.id,
          labels: "name=infra"
        })

      {_, group} = HostGroupContext.create_group(group)

      host =
        HostContext.new_host(%{
          name: "~name~",
          hostname: "~hostname~",
          labels: "~labels~",
          private_ips: "~private_ips~",
          public_ips: "~public_ips~",
          status: "~status~",
          reported_at: DateTime.utc_now(),
          host_group_id: group.id
        })

      {_, host} = HostContext.create_host(host)

      assert host.name == "~name~"
      assert host.hostname == "~hostname~"
      assert host.labels == "~labels~"
      assert host.private_ips == "~private_ips~"
      assert host.public_ips == "~public_ips~"
      assert host.status == "~status~"
      assert host.host_group_id == group.id

      assert host == HostContext.get_host_by_id(host.id)
    end
  end

  describe "get_host_by_uuid/1" do
    test "test get_host_by_uuid" do
      attrs =
        TeamContext.new_team(%{
          name: "team_a",
          description: "team_a"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      group =
        HostGroupContext.new_group(%{
          name: "group_name",
          api_key: "group_api_key",
          team_id: team.id,
          labels: "name=infra"
        })

      {_, group} = HostGroupContext.create_group(group)

      host =
        HostContext.new_host(%{
          name: "~name~",
          hostname: "~hostname~",
          labels: "~labels~",
          private_ips: "~private_ips~",
          public_ips: "~public_ips~",
          status: "~status~",
          reported_at: DateTime.utc_now(),
          host_group_id: group.id
        })

      {_, host} = HostContext.create_host(host)

      assert host.name == "~name~"
      assert host.hostname == "~hostname~"
      assert host.labels == "~labels~"
      assert host.private_ips == "~private_ips~"
      assert host.public_ips == "~public_ips~"
      assert host.status == "~status~"
      assert host.host_group_id == group.id

      assert host == HostContext.get_host_by_uuid(host.uuid)
    end
  end

  describe "update_host/2" do
    test "test update_host" do
      attrs =
        TeamContext.new_team(%{
          name: "team_a",
          description: "team_a"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      group =
        HostGroupContext.new_group(%{
          name: "group_name",
          api_key: "group_api_key",
          team_id: team.id,
          labels: "name=infra"
        })

      {_, group} = HostGroupContext.create_group(group)

      host =
        HostContext.new_host(%{
          name: "~name~",
          hostname: "~hostname~",
          labels: "~labels~",
          private_ips: "~private_ips~",
          public_ips: "~public_ips~",
          status: "~status~",
          reported_at: DateTime.utc_now(),
          host_group_id: group.id
        })

      {_, host} = HostContext.create_host(host)

      assert host.name == "~name~"
      assert host.hostname == "~hostname~"
      assert host.labels == "~labels~"
      assert host.private_ips == "~private_ips~"
      assert host.public_ips == "~public_ips~"
      assert host.status == "~status~"
      assert host.host_group_id == group.id

      assert host == HostContext.get_host_by_id(host.id)
    end
  end

  describe "delete_host/1" do
    test "test delete_host" do
      attrs =
        TeamContext.new_team(%{
          name: "team_a",
          description: "team_a"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      group =
        HostGroupContext.new_group(%{
          name: "group_name",
          api_key: "group_api_key",
          team_id: team.id,
          labels: "name=infra"
        })

      {_, group} = HostGroupContext.create_group(group)

      host =
        HostContext.new_host(%{
          name: "~name~",
          hostname: "~hostname~",
          labels: "~labels~",
          private_ips: "~private_ips~",
          public_ips: "~public_ips~",
          status: "~status~",
          reported_at: DateTime.utc_now(),
          host_group_id: group.id
        })

      {_, host} = HostContext.create_host(host)

      assert host.name == "~name~"
      assert host.hostname == "~hostname~"
      assert host.labels == "~labels~"
      assert host.private_ips == "~private_ips~"
      assert host.public_ips == "~public_ips~"
      assert host.status == "~status~"
      assert host.host_group_id == group.id

      HostContext.delete_host(host)

      assert HostContext.get_host_by_id(host.id) == nil
    end
  end

  describe "get_hosts/0" do
    test "test get_hosts" do
      attrs =
        TeamContext.new_team(%{
          name: "team_a",
          description: "team_a"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      group =
        HostGroupContext.new_group(%{
          name: "group_name",
          api_key: "group_api_key",
          team_id: team.id,
          labels: "name=infra"
        })

      {_, group} = HostGroupContext.create_group(group)

      host =
        HostContext.new_host(%{
          name: "~name~",
          hostname: "~hostname~",
          labels: "~labels~",
          private_ips: "~private_ips~",
          public_ips: "~public_ips~",
          status: "~status~",
          reported_at: DateTime.utc_now(),
          host_group_id: group.id
        })

      {_, host} = HostContext.create_host(host)

      assert host.name == "~name~"
      assert host.hostname == "~hostname~"
      assert host.labels == "~labels~"
      assert host.private_ips == "~private_ips~"
      assert host.public_ips == "~public_ips~"
      assert host.status == "~status~"
      assert host.host_group_id == group.id

      assert HostContext.get_hosts() == [host]
    end
  end

  describe "get_hosts/2" do
    test "test get_hosts" do
      attrs =
        TeamContext.new_team(%{
          name: "team_a",
          description: "team_a"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      group =
        HostGroupContext.new_group(%{
          name: "group_name",
          api_key: "group_api_key",
          team_id: team.id,
          labels: "name=infra"
        })

      {_, group} = HostGroupContext.create_group(group)

      host =
        HostContext.new_host(%{
          name: "~name~",
          hostname: "~hostname~",
          labels: "~labels~",
          private_ips: "~private_ips~",
          public_ips: "~public_ips~",
          status: "~status~",
          reported_at: DateTime.utc_now(),
          host_group_id: group.id
        })

      {_, host} = HostContext.create_host(host)

      assert host.name == "~name~"
      assert host.hostname == "~hostname~"
      assert host.labels == "~labels~"
      assert host.private_ips == "~private_ips~"
      assert host.public_ips == "~public_ips~"
      assert host.status == "~status~"
      assert host.host_group_id == group.id

      assert HostContext.get_hosts(0, 22) == [host]
      assert HostContext.get_hosts(1, 22) == []
    end
  end

  describe "get_hosts_by_host_group/3" do
    test "test get_hosts_by_host_group" do
      attrs =
        TeamContext.new_team(%{
          name: "team_a",
          description: "team_a"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      group =
        HostGroupContext.new_group(%{
          name: "group_name",
          api_key: "group_api_key",
          team_id: team.id,
          labels: "name=infra"
        })

      {_, group} = HostGroupContext.create_group(group)

      host =
        HostContext.new_host(%{
          name: "~name~",
          hostname: "~hostname~",
          labels: "~labels~",
          private_ips: "~private_ips~",
          public_ips: "~public_ips~",
          status: "~status~",
          reported_at: DateTime.utc_now(),
          host_group_id: group.id
        })

      {_, host} = HostContext.create_host(host)

      assert host.name == "~name~"
      assert host.hostname == "~hostname~"
      assert host.labels == "~labels~"
      assert host.private_ips == "~private_ips~"
      assert host.public_ips == "~public_ips~"
      assert host.status == "~status~"
      assert host.host_group_id == group.id

      assert HostContext.get_hosts_by_host_group(group.id, 0, 22) == [host]
      assert HostContext.get_hosts_by_host_group(group.id, 1, 22) == []
      assert HostContext.get_hosts_by_host_group(1000, 0, 22) == []
    end
  end

  describe "create_host_meta/1" do
    test "test create_host_meta" do
      attrs =
        TeamContext.new_team(%{
          name: "team_a",
          description: "team_a"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      group =
        HostGroupContext.new_group(%{
          name: "group_name",
          api_key: "group_api_key",
          team_id: team.id,
          labels: "name=infra"
        })

      {_, group} = HostGroupContext.create_group(group)

      host =
        HostContext.new_host(%{
          name: "~name~",
          hostname: "~hostname~",
          labels: "~labels~",
          private_ips: "~private_ips~",
          public_ips: "~public_ips~",
          status: "~status~",
          reported_at: DateTime.utc_now(),
          host_group_id: group.id
        })

      {_, host} = HostContext.create_host(host)

      meta =
        HostContext.new_meta(%{
          key: "~meta_key~",
          value: "~meta_value~",
          host_id: host.id
        })

      {status, meta} = HostContext.create_host_meta(meta)

      assert status == :ok
      assert meta.host_id == host.id
      assert meta.key == "~meta_key~"
      assert meta.value == "~meta_value~"
    end
  end

  describe "get_host_meta_by_id/1" do
    test "test get_host_meta_by_id" do
      attrs =
        TeamContext.new_team(%{
          name: "team_a",
          description: "team_a"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      group =
        HostGroupContext.new_group(%{
          name: "group_name",
          api_key: "group_api_key",
          team_id: team.id,
          labels: "name=infra"
        })

      {_, group} = HostGroupContext.create_group(group)

      host =
        HostContext.new_host(%{
          name: "~name~",
          hostname: "~hostname~",
          labels: "~labels~",
          private_ips: "~private_ips~",
          public_ips: "~public_ips~",
          status: "~status~",
          reported_at: DateTime.utc_now(),
          host_group_id: group.id
        })

      {_, host} = HostContext.create_host(host)

      meta =
        HostContext.new_meta(%{
          key: "~meta_key~",
          value: "~meta_value~",
          host_id: host.id
        })

      {status, meta} = HostContext.create_host_meta(meta)

      assert status == :ok
      assert meta.host_id == host.id
      assert meta.key == "~meta_key~"
      assert meta.value == "~meta_value~"

      assert meta == HostContext.get_host_meta_by_id(meta.id)
    end
  end

  describe "update_host_meta/2" do
    test "test update_host_meta" do
      attrs =
        TeamContext.new_team(%{
          name: "team_a",
          description: "team_a"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      group =
        HostGroupContext.new_group(%{
          name: "group_name",
          api_key: "group_api_key",
          team_id: team.id,
          labels: "name=infra"
        })

      {_, group} = HostGroupContext.create_group(group)

      host =
        HostContext.new_host(%{
          name: "~name~",
          hostname: "~hostname~",
          labels: "~labels~",
          private_ips: "~private_ips~",
          public_ips: "~public_ips~",
          status: "~status~",
          reported_at: DateTime.utc_now(),
          host_group_id: group.id
        })

      {_, host} = HostContext.create_host(host)

      meta =
        HostContext.new_meta(%{
          key: "~meta_key~",
          value: "~meta_value~",
          host_id: host.id
        })

      {status, meta} = HostContext.create_host_meta(meta)

      assert status == :ok
      assert meta.host_id == host.id
      assert meta.key == "~meta_key~"
      assert meta.value == "~meta_value~"

      HostContext.update_host_meta(meta, %{
        key: "~new_meta_key~",
        value: "~new_meta_value~"
      })

      meta = HostContext.get_host_meta_by_id(meta.id)

      assert meta.key == "~new_meta_key~"
      assert meta.value == "~new_meta_value~"
    end
  end

  describe "delete_host_meta/1" do
    test "test delete_host_meta" do
      attrs =
        TeamContext.new_team(%{
          name: "team_a",
          description: "team_a"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      group =
        HostGroupContext.new_group(%{
          name: "group_name",
          api_key: "group_api_key",
          team_id: team.id,
          labels: "name=infra"
        })

      {_, group} = HostGroupContext.create_group(group)

      host =
        HostContext.new_host(%{
          name: "~name~",
          hostname: "~hostname~",
          labels: "~labels~",
          private_ips: "~private_ips~",
          public_ips: "~public_ips~",
          status: "~status~",
          reported_at: DateTime.utc_now(),
          host_group_id: group.id
        })

      {_, host} = HostContext.create_host(host)

      meta =
        HostContext.new_meta(%{
          key: "~meta_key~",
          value: "~meta_value~",
          host_id: host.id
        })

      {status, meta} = HostContext.create_host_meta(meta)

      assert status == :ok
      assert meta.host_id == host.id
      assert meta.key == "~meta_key~"
      assert meta.value == "~meta_value~"

      assert meta == HostContext.get_host_meta_by_id(meta.id)

      HostContext.delete_host_meta(meta)

      assert HostContext.get_host_meta_by_id(meta.id) == nil
    end
  end

  describe "get_host_meta_by_id_key/2" do
    test "test get_host_meta_by_id_key" do
      attrs =
        TeamContext.new_team(%{
          name: "team_a",
          description: "team_a"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      group =
        HostGroupContext.new_group(%{
          name: "group_name",
          api_key: "group_api_key",
          team_id: team.id,
          labels: "name=infra"
        })

      {_, group} = HostGroupContext.create_group(group)

      host =
        HostContext.new_host(%{
          name: "~name~",
          hostname: "~hostname~",
          labels: "~labels~",
          private_ips: "~private_ips~",
          public_ips: "~public_ips~",
          status: "~status~",
          reported_at: DateTime.utc_now(),
          host_group_id: group.id
        })

      {_, host} = HostContext.create_host(host)

      meta =
        HostContext.new_meta(%{
          key: "~meta_key~",
          value: "~meta_value~",
          host_id: host.id
        })

      {status, meta} = HostContext.create_host_meta(meta)

      assert status == :ok
      assert meta.host_id == host.id
      assert meta.key == "~meta_key~"
      assert meta.value == "~meta_value~"

      assert meta == HostContext.get_host_meta_by_id_key(host.id, "~meta_key~")
    end
  end

  describe "get_host_metas/1" do
    test "test get_host_metas" do
      attrs =
        TeamContext.new_team(%{
          name: "team_a",
          description: "team_a"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      group =
        HostGroupContext.new_group(%{
          name: "group_name",
          api_key: "group_api_key",
          team_id: team.id,
          labels: "name=infra"
        })

      {_, group} = HostGroupContext.create_group(group)

      host =
        HostContext.new_host(%{
          name: "~name~",
          hostname: "~hostname~",
          labels: "~labels~",
          private_ips: "~private_ips~",
          public_ips: "~public_ips~",
          status: "~status~",
          reported_at: DateTime.utc_now(),
          host_group_id: group.id
        })

      {_, host} = HostContext.create_host(host)

      meta =
        HostContext.new_meta(%{
          key: "~meta_key~",
          value: "~meta_value~",
          host_id: host.id
        })

      {status, meta} = HostContext.create_host_meta(meta)

      assert status == :ok
      assert meta.host_id == host.id
      assert meta.key == "~meta_key~"
      assert meta.value == "~meta_value~"

      assert HostContext.get_host_metas(host.id) == [meta]
      assert HostContext.get_host_metas(1000) == []
    end
  end
end
