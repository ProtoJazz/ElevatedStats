defmodule ElevatedStatsWeb.SummonerLive.Index do
  use ElevatedStatsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # {:ok, stream(socket, :home, Summoners.list_home())}
    {:ok, assign(socket, :summoner_name, "Shaft")}
  end

  def handle_event("handle_summoner_submit", %{"summoner_name" => summoner_name}, socket) do
    IO.puts("WE HANDLED SHAFTS")
    {:noreply, socket |> assign(:summoner_name, summoner_name)}
  end
end
