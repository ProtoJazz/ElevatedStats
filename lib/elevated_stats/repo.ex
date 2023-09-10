defmodule ElevatedStats.Repo do
  use Ecto.Repo,
    otp_app: :elevated_stats,
    adapter: Ecto.Adapters.Postgres
end
