# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Context.UserContextTest do
  @moduledoc """
  User Context Test Cases
  """
  use ExUnit.Case

  alias Meerkat.Context.UserContext
  alias Meerkat.Context.TeamContext

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Meerkat.Repo)
  end

  describe "new_user/1" do
    test "test new_user method" do
      user =
        UserContext.new_user(%{
          email: "hello@clivern.com",
          name: "Clivern",
          password_hash: "27hd7wh2",
          verified: true,
          last_seen: DateTime.utc_now(),
          role: "super",
          api_key: "x-x-x-x-x"
        })

      assert user.email == "hello@clivern.com"
      assert user.name == "Clivern"
      assert user.password_hash == "27hd7wh2"
      assert user.verified == true
      assert user.role == "super"
      assert user.api_key == "x-x-x-x-x"
      assert is_binary(user.uuid) == true
    end
  end

  describe "new_meta/1" do
    test "test new_meta method" do
      meta =
        UserContext.new_meta(%{
          key: "meta_key",
          value: "meta_value",
          user_id: 1
        })

      assert meta.user_id == 1
      assert meta.key == "meta_key"
      assert meta.value == "meta_value"
    end
  end

  describe "new_session/1" do
    test "test new_session method" do
      session =
        UserContext.new_session(%{
          expire_at: "expire_at",
          value: "meta_value",
          user_id: 1
        })

      assert session.user_id == 1
      assert session.expire_at == "expire_at"
      assert session.value == "meta_value"
    end
  end

  describe "create_user/1" do
    test "test create_user method" do
      attr =
        UserContext.new_user(%{
          email: "hello@clivern.com",
          name: "Clivern",
          password_hash: "27hd7wh2",
          verified: true,
          last_seen: DateTime.utc_now(),
          role: "super",
          api_key: "x-x-x-x-x"
        })

      {status, user} = UserContext.create_user(attr)

      assert status == :ok
      assert user.email == "hello@clivern.com"
      assert is_binary(user.uuid)
    end
  end

  describe "get_user_by_id/1" do
    test "test get_user_by_id method" do
      attr =
        UserContext.new_user(%{
          email: "hello@clivern.com",
          name: "Clivern",
          password_hash: "27hd7wh2",
          verified: true,
          last_seen: DateTime.utc_now(),
          role: "super",
          api_key: "x-x-x-x-x"
        })

      {status, user} = UserContext.create_user(attr)

      assert status == :ok
      assert user.email == "hello@clivern.com"
      assert is_binary(user.uuid)

      result = UserContext.get_user_by_id(user.id)

      assert result == user
    end
  end

  describe "get_user_by_uuid/1" do
    test "test get_user_by_uuid method" do
      attr =
        UserContext.new_user(%{
          email: "hello@clivern.com",
          name: "Clivern",
          password_hash: "27hd7wh2",
          verified: true,
          last_seen: DateTime.utc_now(),
          role: "super",
          api_key: "x-x-x-x-x"
        })

      {status, user} = UserContext.create_user(attr)

      assert status == :ok
      assert user.email == "hello@clivern.com"
      assert is_binary(user.uuid)

      result = UserContext.get_user_by_uuid(user.uuid)

      assert result == user
    end
  end

  describe "get_user_by_api_key/1" do
    test "test get_user_by_api_key method" do
      attr =
        UserContext.new_user(%{
          email: "hello@clivern.com",
          name: "Clivern",
          password_hash: "27hd7wh2",
          verified: true,
          last_seen: DateTime.utc_now(),
          role: "super",
          api_key: "x-x-x-x-x"
        })

      {status, user} = UserContext.create_user(attr)

      assert status == :ok
      assert user.email == "hello@clivern.com"
      assert is_binary(user.uuid)

      result = UserContext.get_user_by_api_key(user.api_key)

      assert result == user
    end
  end

  describe "get_user_by_email/1" do
    test "test get_user_by_email method" do
      attr =
        UserContext.new_user(%{
          email: "hello@clivern.com",
          name: "Clivern",
          password_hash: "27hd7wh2",
          verified: true,
          last_seen: DateTime.utc_now(),
          role: "super",
          api_key: "x-x-x-x-x"
        })

      {status, user} = UserContext.create_user(attr)

      assert status == :ok
      assert user.email == "hello@clivern.com"
      assert is_binary(user.uuid)

      result = UserContext.get_user_by_email(user.email)

      assert result == user
    end
  end

  describe "update_user/2" do
    test "test update_user method" do
      attr =
        UserContext.new_user(%{
          email: "hello@clivern.com",
          name: "Clivern",
          password_hash: "27hd7wh2",
          verified: true,
          last_seen: DateTime.utc_now(),
          role: "super",
          api_key: "x-x-x-x-x"
        })

      {status, user} = UserContext.create_user(attr)

      assert status == :ok
      assert user.email == "hello@clivern.com"
      assert is_binary(user.uuid)

      {_, result} = UserContext.update_user(user, %{email: "hi@clivern.com"})

      assert result.email == "hi@clivern.com"
    end
  end

  describe "delete_user/1" do
    test "test delete_user method" do
      attr =
        UserContext.new_user(%{
          email: "hello@clivern.com",
          name: "Clivern",
          password_hash: "27hd7wh2",
          verified: true,
          last_seen: DateTime.utc_now(),
          role: "super",
          api_key: "x-x-x-x-x"
        })

      {_, user} = UserContext.create_user(attr)

      UserContext.delete_user(user)

      assert UserContext.get_user_by_id(user.id) == nil
    end
  end

  describe "get_users/0" do
    test "test get_users method" do
      attr =
        UserContext.new_user(%{
          email: "hello@clivern.com",
          name: "Clivern",
          password_hash: "27hd7wh2",
          verified: true,
          last_seen: DateTime.utc_now(),
          role: "super",
          api_key: "x-x-x-x-x"
        })

      {_, user} = UserContext.create_user(attr)

      assert UserContext.get_users() == [user]
    end
  end

  describe "get_users/2" do
    test "test get_users method" do
      attr =
        UserContext.new_user(%{
          email: "hello@clivern.com",
          name: "Clivern",
          password_hash: "27hd7wh2",
          verified: true,
          last_seen: DateTime.utc_now(),
          role: "super",
          api_key: "x-x-x-x-x"
        })

      {_, user} = UserContext.create_user(attr)

      assert UserContext.get_users(0, 1) == [user]
      assert UserContext.get_users(1, 1) == []
    end
  end

  describe "count_users/0" do
    test "test count_users method" do
      attr =
        UserContext.new_user(%{
          email: "hello@clivern.com",
          name: "Clivern",
          password_hash: "27hd7wh2",
          verified: true,
          last_seen: DateTime.utc_now(),
          role: "super",
          api_key: "x-x-x-x-x"
        })

      UserContext.create_user(attr)

      assert UserContext.count_users() == 1
    end
  end

  describe "create_user_meta/1" do
    test "test case" do
    end
  end

  describe "create_user_session/1" do
    test "test case" do
    end
  end

  describe "get_user_meta_by_id/1" do
    test "test case" do
    end
  end

  describe "update_user_meta/2" do
    test "test case" do
    end
  end

  describe "update_user_session/2" do
    test "test case" do
    end
  end

  describe "delete_user_meta/1" do
    test "test case" do
    end
  end

  describe "delete_user_session/1" do
    test "test case" do
    end
  end

  describe "delete_user_sessions/1" do
    test "test case" do
    end
  end

  describe "get_user_meta_by_id_key/2" do
    test "test case" do
    end
  end

  describe "get_user_session_by_id_key/2" do
    test "test case" do
    end
  end

  describe "get_user_sessions/1" do
    test "test case" do
    end
  end

  describe "get_user_metas/1" do
    test "test case" do
    end
  end

  describe "add_user_to_team/2" do
    test "test case" do
    end
  end

  describe "remove_user_from_team/2" do
    test "test case" do
    end
  end

  describe "remove_user_from_team_by_uuid/1" do
    test "test case" do
    end
  end

  describe "get_user_teams/1" do
    test "test case" do
    end
  end

  describe "get_team_users/1" do
    test "test case" do
    end
  end

  describe "validate_user_id/1" do
    test "test validate_user_id method" do
      attr =
        UserContext.new_user(%{
          email: "hello@clivern.com",
          name: "Clivern",
          password_hash: "27hd7wh2",
          verified: true,
          last_seen: DateTime.utc_now(),
          role: "super",
          api_key: "x-x-x-x-x"
        })

      {status, user} = UserContext.create_user(attr)

      assert status == :ok
      assert user.email == "hello@clivern.com"
      assert is_binary(user.uuid)

      assert UserContext.validate_user_id(user.id) == true
    end
  end

  describe "validate_team_id/1" do
    test "test case" do
      attrs =
        TeamContext.new_team(%{
          name: "Team 2",
          description: "Description 2"
        })

      {status, team} = TeamContext.create_team(attrs)

      assert status == :ok

      assert team.name == "Team 2"
      assert team.description == "Description 2"
      assert is_binary(team.uuid)

      assert UserContext.validate_team_id(team.id) == true
    end
  end
end
