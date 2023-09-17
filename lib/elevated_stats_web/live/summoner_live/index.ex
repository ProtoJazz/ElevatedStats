defmodule ElevatedStatsWeb.SummonerLive.Index do
  use ElevatedStatsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # {:ok, stream(socket, :home, Summoners.list_home())}
    {:ok, socket}
  end

  def handle_event("handle_summoner_submit", %{"summoner_name" => summoner_name}, socket) do
    IO.puts("WE HANDLED SHAFTS")
    ElevatedStats.Users.create_account(%{"summoner_name" => summoner_name})
    ElevatedStats.MatchServer.new_user_added()
    {:noreply, socket |> assign(:summoner_name, summoner_name)}
  end
end
