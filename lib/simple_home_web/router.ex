defmodule SimpleHomeWeb.Router do
  use SimpleHomeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SimpleHomeWeb.UserAuth
    plug SimpleHomeWeb.CartSession
    plug :put_root_layout, {SimpleHomeWeb.LayoutView, :root}
  end

  pipeline :authorize do
    plug SimpleHomeWeb.Authorization
  end

  scope "/", SimpleHomeWeb do
    pipe_through :browser

    live "/", PageLive.Index, :index
    live "/users/new", UserLive.New, :new
    resources "/sessions", UserSessionController, only: [:new, :create, :delete]
    live "/carts", CartLive.Index, :index
    pipe_through :authorize
    live "/products/new", ProductLive.New, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", SimpleHomeWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # if Mix.env() in [:dev, :test] do
  #   import Phoenix.LiveDashboard.Router

  #   scope "/" do
  #     pipe_through :browser
  #     live_dashboard "/dashboard", metrics: SimpleHomeWeb.Telemetry
  #   end
  # end
end
