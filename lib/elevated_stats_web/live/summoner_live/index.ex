defmodule ElevatedStatsWeb.SummonerLive.Index do
  use ElevatedStatsWeb, :live_view
  alias ElevatedStats.{Users, MatchServer}
  @impl true
  def mount(_params, _session, socket) do
    # {:ok, stream(socket, :home, Summoners.list_home())}
    {:ok, socket}
  end

  def handle_event("handle_summoner_submit", %{"summoner_name" => summoner_name}, socket) do
    summoner_name = String.downcase(summoner_name)
    existing_user = Users.get_account_by_summoner_name(summoner_name)

    if(!existing_user) do
      Users.create_account(%{"summoner_name" => summoner_name})
      MatchServer.new_user_added()
      {:noreply, socket |> assign(:summoner_name, summoner_name)}
    else
      {:noreply, push_navigate(socket, to: "/stats/#{summoner_name}", replace: true)}
    end
  end
end
