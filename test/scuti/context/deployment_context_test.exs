# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.DeploymentContextTest do
  @moduledoc """
  Deployment Context Test Cases
  """
  use ExUnit.Case

  alias Scuti.Context.TeamContext
  alias Scuti.Context.DeploymentContext

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Scuti.Repo)
  end

  describe "new_deployment/1" do
    test "new_deployment/1 test cases" do
    end
  end
end
