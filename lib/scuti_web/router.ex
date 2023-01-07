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
    get "/login", PageController, :login
    get "/logout", PageController, :logout

    get "/admin/group", PageController, :list_groups
    get "/admin/group/edit/:id", PageController, :edit_group
    get "/admin/group/add", PageController, :add_group

    get "/admin/host", PageController, :list_hosts
    get "/admin/host/edit/:id", PageController, :edit_host
    get "/admin/host/add", PageController, :add_host

    get "/admin/deployment", PageController, :list_deployments
    get "/admin/deployment/edit/:id", PageController, :edit_deployment
    get "/admin/deployment/add", PageController, :add_deployment

    get "/admin/team", PageController, :list_teams
    get "/admin/team/edit/:id", PageController, :edit_team
    get "/admin/team/add", PageController, :add_team

    get "/admin/user", PageController, :list_users
    get "/admin/user/edit/:id", PageController, :edit_user
    get "/admin/user/add", PageController, :add_user

    get "/admin/settings", PageController, :settings
  end

  scope "/", ScutiWeb do
    pipe_through :pub

    get "/_health", HealthController, :health
    get "/_ready", ReadyController, :ready
    post "/action/install", MiscController, :install
    post "/action/auth", MiscController, :auth
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
    get "/hostGroup/:hgid/host", HostController, :list
    post "/hostGroup/:hgid/host", HostController, :create
    get "/hostGroup/:hgid/host/:hid", HostController, :index
    put "/hostGroup/:hgid/host/:hid", HostController, :update
    delete "/hostGroup/:hgid/host/:hid", HostController, :delete

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
