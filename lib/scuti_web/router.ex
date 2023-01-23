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
    plug Scuti.Middleware.Logger
    plug Scuti.Middleware.UIAuthMiddleware
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Scuti.Middleware.Logger
    plug Scuti.Middleware.APIAuthMiddleware
  end

  pipeline :pub do
    plug :accepts, ["json"]
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
    get "/admin/group", PageController, :list_groups
    get "/admin/group/:id", PageController, :view_group

    get "/admin/deployment", PageController, :list_deployments
    get "/admin/deployment/add", PageController, :add_deployment
    get "/admin/deployment/edit/:id", PageController, :edit_deployment
    get "/admin/deployment/view/:id", PageController, :view_deployment

    get "/admin/team", PageController, :list_teams
    get "/admin/user", PageController, :list_users
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
    post "/action/v1/agent/report/:group_uuid/:host_uuid", AgentController, :report
  end

  scope "/api/v1", ScutiWeb do
    pipe_through :api

    # User CRUD
    get "/user", UserController, :list
    post "/user", UserController, :create
    get "/user/:id", UserController, :index
    put "/user/:id", UserController, :update
    delete "/user/:id", UserController, :delete

    # Team CRUD
    get "/team", TeamController, :list
    post "/team", TeamController, :create
    get "/team/:id", TeamController, :index
    put "/team/:id", TeamController, :update
    delete "/team/:id", TeamController, :delete

    # Settings Endpoint
    put "/settings", SettingsController, :update

    # HostGroup CRUD
    get "/hostGroup", HostGroupController, :list
    post "/hostGroup", HostGroupController, :create
    get "/hostGroup/:id", HostGroupController, :index
    put "/hostGroup/:id", HostGroupController, :update
    delete "/hostGroup/:id", HostGroupController, :delete

    # Host CRUD
    get "/hostGroup/:group_id/host", HostController, :list
    post "/hostGroup/:group_id/host", HostController, :create
    get "/hostGroup/:group_id/host/:host_id", HostController, :index
    put "/hostGroup/:group_id/host/:host_id", HostController, :update
    delete "/hostGroup/:group_id/host/:host_id", HostController, :delete

    # Deployment CRUD
    get "/deployment", DeploymentController, :list
    post "/deployment", DeploymentController, :create
    get "/deployment/:id", DeploymentController, :index
    put "/deployment/:id", DeploymentController, :update
    delete "/deployment/:id", DeploymentController, :delete

    # Task CRUD
    get "/task", TaskController, :list
    post "/task", TaskController, :create
    get "/task/:id", TaskController, :index
    put "/task/:id", TaskController, :update
    delete "/task/:id", TaskController, :delete

    # Profile Endpoint
    post "/profile", ProfileController, :update
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
