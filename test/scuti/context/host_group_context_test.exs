# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.HostGroupContextTest do
  @moduledoc """
  Host Group Context Test Cases
  """
  use ExUnit.Case

  alias Scuti.Context.TeamContext
  alias Scuti.Context.HostGroupContext

  # Init
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Scuti.Repo)
  end

  # Test Cases
  describe "new_group/1" do
    test "new_group/1 test cases" do
      group =
        HostGroupContext.new_group(%{
          name: "group_name",
          api_key: "group_api_key",
          team_id: 1,
          labels: "name=infra",
          remote_join: false
        })

      assert group.name == "group_name"
      assert group.api_key == "group_api_key"
      assert group.team_id == 1
      assert group.labels == "name=infra"
    end
  end

  describe "new_meta/1" do
    test "test new_meta" do
      meta =
        HostGroupContext.new_meta(%{
          key: "meta_key",
          value: "meta_value",
          host_group_id: 1
        })

      assert meta.host_group_id == 1
      assert meta.key == "meta_key"
      assert meta.value == "meta_value"
    end
  end

  describe "create_group/1" do
    test "test create_group" do
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
          labels: "name=infra",
          remote_join: false
        })

      {status, group} = HostGroupContext.create_group(group)

      assert status == :ok
      assert group.name == "group_name"
      assert group.api_key == "group_api_key"
      assert group.team_id == team.id
      assert group.labels == "name=infra"
    end
  end

  describe "get_group_by_id/1" do
    test "test get_group_by_id" do
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
          labels: "name=infra",
          remote_join: false
        })

      {status, group} = HostGroupContext.create_group(group)

      assert status == :ok
      assert group == HostGroupContext.get_group_by_id(group.id)
    end
  end

  describe "get_group_by_uuid/1" do
    test "test get_group_by_uuid" do
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
          labels: "name=infra",
          remote_join: false
        })

      {status, group} = HostGroupContext.create_group(group)

      assert status == :ok
      assert group == HostGroupContext.get_group_by_uuid(group.uuid)
    end
  end

  describe "update_group/2" do
    test "test update_group" do
    end
  end

  describe "delete_group/1" do
    test "test delete_group" do
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
          labels: "name=infra",
          remote_join: false
        })

      {status, group} = HostGroupContext.create_group(group)

      HostGroupContext.delete_group(group)

      assert status == :ok
      assert HostGroupContext.get_group_by_id(group.id) == nil
    end
  end

  describe "get_groups/0" do
    test "test get_groups" do
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
          labels: "name=infra",
          remote_join: false
        })

      {_, group} = HostGroupContext.create_group(group)

      assert HostGroupContext.get_groups() == [group]

      HostGroupContext.delete_group(group)

      assert HostGroupContext.get_groups() == []
    end
  end

  describe "get_groups/2" do
    test "test get_groups" do
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
          labels: "name=infra",
          remote_join: false
        })

      {_, group} = HostGroupContext.create_group(group)

      assert HostGroupContext.get_groups(0, 2) == [group]

      HostGroupContext.delete_group(group)

      assert HostGroupContext.get_groups(0, 2) == []
    end
  end

  describe "get_groups_by_team/3" do
    test "test get_groups_by_team" do
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
          labels: "name=infra",
          remote_join: false
        })

      {_, group} = HostGroupContext.create_group(group)

      assert HostGroupContext.get_groups_by_team(team.id, 0, 2) == [group]
      assert HostGroupContext.get_groups_by_team(1000, 0, 2) == []

      HostGroupContext.delete_group(group)

      assert HostGroupContext.get_groups_by_team(team.id, 0, 2) == []
    end
  end

  describe "create_group_meta/1" do
    test "test create_group_meta" do
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
          labels: "name=infra",
          remote_join: false
        })

      {_, group} = HostGroupContext.create_group(group)

      meta =
        HostGroupContext.new_meta(%{
          key: "meta_key",
          value: "meta_value",
          host_group_id: group.id
        })

      {status, meta} = HostGroupContext.create_group_meta(meta)

      assert status == :ok
      assert meta.host_group_id == group.id
      assert meta.key == "meta_key"
      assert meta.value == "meta_value"
    end
  end

  describe "get_group_meta_by_id/1" do
    test "test get_group_meta_by_id" do
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
          labels: "name=infra",
          remote_join: false
        })

      {_, group} = HostGroupContext.create_group(group)

      meta =
        HostGroupContext.new_meta(%{
          key: "meta_key",
          value: "meta_value",
          host_group_id: group.id
        })

      {status, meta} = HostGroupContext.create_group_meta(meta)

      assert status == :ok
      assert meta == HostGroupContext.get_group_meta_by_id(meta.id)
    end
  end

  describe "update_group_meta/2" do
    test "test update_group_meta" do
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
          labels: "name=infra",
          remote_join: false
        })

      {_, group} = HostGroupContext.create_group(group)

      meta =
        HostGroupContext.new_meta(%{
          key: "meta_key",
          value: "meta_value",
          host_group_id: group.id
        })

      {status, meta} = HostGroupContext.create_group_meta(meta)

      assert status == :ok
      assert meta == HostGroupContext.get_group_meta_by_id_key(group.id, "meta_key")

      {status, new_meta} =
        HostGroupContext.update_group_meta(meta, %{
          key: "new_meta_key",
          value: "new_meta_value"
        })

      assert status == :ok
      assert new_meta.key == "new_meta_key"
      assert new_meta.value == "new_meta_value"
    end
  end

  describe "delete_group_meta/1" do
    test "test delete_group_meta" do
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
          labels: "name=infra",
          remote_join: false
        })

      {_, group} = HostGroupContext.create_group(group)

      meta =
        HostGroupContext.new_meta(%{
          key: "meta_key",
          value: "meta_value",
          host_group_id: group.id
        })

      {status, meta} = HostGroupContext.create_group_meta(meta)

      assert status == :ok
      assert meta == HostGroupContext.get_group_meta_by_id(meta.id)

      HostGroupContext.delete_group_meta(meta)

      assert HostGroupContext.get_group_meta_by_id(meta.id) == nil
    end
  end

  describe "get_group_meta_by_id_key/2" do
    test "test get_group_meta_by_id_key" do
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
          labels: "name=infra",
          remote_join: false
        })

      {_, group} = HostGroupContext.create_group(group)

      meta =
        HostGroupContext.new_meta(%{
          key: "meta_key",
          value: "meta_value",
          host_group_id: group.id
        })

      {status, meta} = HostGroupContext.create_group_meta(meta)

      assert status == :ok
      assert meta == HostGroupContext.get_group_meta_by_id_key(group.id, "meta_key")
    end
  end
end
