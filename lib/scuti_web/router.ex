# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule ScutiWeb.Router do
  use ScutiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ScutiWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :add_server_header
    plug Scuti.Middleware.Logger
    plug Scuti.Middleware.UIAuthMiddleware
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :add_server_header
    plug Scuti.Middleware.Logger
    plug Scuti.Middleware.APIAuthMiddleware
  end

  pipeline :pub do
    plug :accepts, ["json"]
    plug :add_server_header
    plug Scuti.Middleware.Logger
  end

  scope "/", ScutiWeb do
    pipe_through :browser

    get "/install", PageController, :install
    get "/", PageController, :home
    get "/404", PageController, :not_found
    get "/login", PageController, :login
    get "/logout", PageController, :logout

    get "/admin/dashboard", PageController, :dashboard
    get "/admin/profile", PageController, :profile

    get "/admin/groups", PageController, :groups
    get "/admin/groups/view/:uuid", PageController, :group

    get "/admin/deployments", PageController, :deployments
    get "/admin/deployments/add", PageController, :add_deployment
    get "/admin/deployments/edit/:uuid", PageController, :edit_deployment
    get "/admin/deployments/view/:uuid", PageController, :deployment

    get "/admin/teams", PageController, :teams
    get "/admin/users", PageController, :users
    get "/admin/settings", PageController, :settings
  end

  scope "/", ScutiWeb do
    pipe_through :pub

    get "/_health", HealthController, :health
    get "/_ready", ReadyController, :ready

    post "/action/v1/install", MiscController, :install
    post "/action/v1/auth", MiscController, :auth

    post "/action/v1/agent/join/:group_uuid/:host_uuid", AgentController, :join
    post "/action/v1/agent/heartbeat/:group_uuid/:host_uuid", AgentController, :heartbeat
    post "/action/v1/agent/report/:group_uuid/:host_uuid/:task_uuid", AgentController, :report
  end

  scope "/api/v1", ScutiWeb do
    pipe_through :api

    # User CRUD
    get "/user", UserController, :list
    post "/user", UserController, :create
    get "/user/:uuid", UserController, :index
    put "/user/:uuid", UserController, :update
    delete "/user/:uuid", UserController, :delete

    # Team CRUD
    get "/team", TeamController, :list
    post "/team", TeamController, :create
    get "/team/:uuid", TeamController, :index
    put "/team/:uuid", TeamController, :update
    delete "/team/:uuid", TeamController, :delete

    # HostGroup CRUD
    get "/group", HostGroupController, :list
    post "/group", HostGroupController, :create
    get "/group/:uuid", HostGroupController, :index
    put "/group/:uuid", HostGroupController, :update
    delete "/group/:uuid", HostGroupController, :delete

    # Host CRUD
    get "/group/:group_uuid/host", HostController, :list
    post "/group/:group_uuid/host", HostController, :create
    get "/group/:group_uuid/host/:host_uuid", HostController, :index
    put "/group/:group_uuid/host/:host_uuid", HostController, :update
    delete "/group/:group_uuid/host/:host_uuid", HostController, :delete

    # Deployment CRUD
    get "/deployment", DeploymentController, :list
    post "/deployment", DeploymentController, :create
    get "/deployment/:uuid", DeploymentController, :index
    put "/deployment/:uuid", DeploymentController, :update
    delete "/deployment/:uuid", DeploymentController, :delete

    # Task CRUD
    get "/task/:uuid", TaskController, :index

    # Settings Endpoints
    put "/action/update_settings", SettingsController, :update
    # Profile Endpoints
    put "/action/update_profile", ProfileController, :update
    # Fetch API Key Endpoint
    get "/action/fetch_api_key", ProfileController, :fetch_api_key
    # Rotate API Key Endpoint
    put "/action/rotate_api_key", ProfileController, :rotate_api_key
  end

  defp add_server_header(conn, _opts) do
    conn
    |> put_resp_header("x-server-version", "scuti/0.5.11")
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ScutiWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
