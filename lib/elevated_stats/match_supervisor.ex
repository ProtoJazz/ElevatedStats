defmodule ElevatedStats.MatchSupervisor do
  use Supervisor

  def start_link(args) do
    IO.inspect(args)
    IO.puts("STARTING SUPA")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      ElevatedStats.MatchServer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
