defmodule KakeguruiBankWeb.Router do
  use KakeguruiBankWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {KakeguruiBankWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug KakeguruiBankWeb.Plugs.AuthTokenPlug
  end

  scope "/api", KakeguruiBankWeb do
    pipe_through :api

    # warning: PUBLIC endpoints below
    get "/health", HealthController, :index
    post "/authentication", AuthenticationController, :index
    resources "/users", UserController, only: [:create]
    # warning: PUBLIC endpoints above
  end

  scope "/api", KakeguruiBankWeb do
    pipe_through :api
    pipe_through :authenticated

    # auth
    resources "/users", UserController, only: [:show]
    get "/authentication", AuthenticationCheckController, :index
    # financial
    resources "/fin_transactions", FinTransactionController, only: [:index, :create]
    get "/balance", BalanceController, :index
    post "/fin_transactions/:uuid/refund", FinTransactionRefundController, :index
  end

  scope "/", KakeguruiBankWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", KakeguruiBankWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:kakegurui_bank, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: KakeguruiBankWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
