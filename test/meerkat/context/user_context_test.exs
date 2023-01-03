# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Context.UserContextTest do
  @moduledoc """
  User Context Test Cases
  """
  use ExUnit.Case

  alias Meerkat.Context.UserContext

  describe "new_user/1" do
    test "test case" do
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
    test "test case" do
    end
  end

  describe "new_session/1" do
    test "test case" do
    end
  end

  describe "create_user/1" do
    test "test case" do
    end
  end

  describe "get_user_by_id/1" do
    test "test case" do
    end
  end

  describe "get_user_by_uuid/1" do
    test "test case" do
    end
  end

  describe "get_user_by_api_key/1" do
    test "test case" do
    end
  end

  describe "get_user_by_email/1" do
    test "test case" do
    end
  end

  describe "update_user/2" do
    test "test case" do
    end
  end

  describe "delete_user/1" do
    test "test case" do
    end
  end

  describe "get_users/0" do
    test "test case" do
    end
  end

  describe "get_users/2" do
    test "test case" do
    end
  end

  describe "count_users/0" do
    test "test case" do
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
    test "test case" do
    end
  end

  describe "validate_team_id/1" do
    test "test case" do
    end
  end
end
