defmodule ElevatedStatsWeb.Router do
  use ElevatedStatsWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {ElevatedStatsWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ElevatedStatsWeb do
    pipe_through(:browser)
    live("/home", SummonerLive.Index, :index)
    live("/stats/:id", StatsLive.Show, :show)
  end

  # Other scopes may use custom stacks.
  scope "/api", ElevatedStatsWeb do
    pipe_through(:api)
    resources("/accounts", AccountController)
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:elevated_stats, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: ElevatedStatsWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
