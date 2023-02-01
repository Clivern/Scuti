# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Meerkat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Meerkat.Repo,
      # Start the Telemetry supervisor
      MeerkatWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Meerkat.PubSub},
      # Start the Endpoint (http/https)
      MeerkatWeb.Endpoint
      # Start a worker by calling: Meerkat.Worker.start_link(arg)
      # {Meerkat.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Meerkat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MeerkatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
