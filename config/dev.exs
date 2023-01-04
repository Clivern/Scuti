# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

import Config

# Configure your database
if System.get_env("DB_SSL") || "off" == "on" do
  config :scuti, Scuti.Repo,
    username: System.get_env("DB_USERNAME") || "scuti",
    password: System.get_env("DB_PASSWORD") || "scuti",
    hostname: System.get_env("DB_HOSTNAME") || "localhost",
    database: System.get_env("DB_DATABASE") || "scuti_dev",
    port: String.to_integer(System.get_env("DB_PORT") || "5432"),
    maintenance_database: System.get_env("DB_DATABASE") || "scuti_dev",
    stacktrace: true,
    show_sensitive_data_on_connection_error: true,
    pool_size: String.to_integer(System.get_env("DB_POOL_SIZE") || "10"),
    ssl: true,
    ssl_opts: [
      verify: :verify_peer,
      cacertfile: System.get_env("DB_CA_CERTFILE_PATH") || ""
    ]
else
  config :scuti, Scuti.Repo,
    username: System.get_env("DB_USERNAME") || "scuti",
    password: System.get_env("DB_PASSWORD") || "scuti",
    hostname: System.get_env("DB_HOSTNAME") || "localhost",
    database: System.get_env("DB_DATABASE") || "scuti_dev",
    port: String.to_integer(System.get_env("DB_PORT") || "5432"),
    maintenance_database: System.get_env("DB_DATABASE") || "scuti_dev",
    stacktrace: true,
    show_sensitive_data_on_connection_error: true,
    pool_size: String.to_integer(System.get_env("DB_POOL_SIZE") || "10")
end

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :scuti, ScutiWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: String.to_integer(System.get_env("APP_PORT") || "4000")],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: System.get_env("APP_SECRET") || "koPmu7TJCwD8mttV9vgWUeU7iuu/zTPOR3sX4UalM9KkYEVGPfyi0PeTVzu1TT8C",
  watchers: [
    # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :scuti, ScutiWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/scuti_web/(live|views)/.*(ex)$",
      ~r"lib/scuti_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
