defmodule ElevatedStatsWeb.StatsLive.Show do
  use ElevatedStatsWeb, :live_view

  alias ElevatedStats.{Matches, Users}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    IO.inspect(id)
    IO.puts("WE DO IT ")
    summoner = Users.get_summoner_by_name(id)

    if(is_nil(summoner)) do
      # get stats
      {:noreply, socket |> assign(:summoner, %{})}
    else
      matches = Matches.get_stats_for_summoner(summoner.puuid)
      IO.puts("We got data")
      IO.inspect(matches)

      {:noreply,
       socket
       |> assign(summoner: summoner, matches: matches)
       |> push_event("chart", %{data: matches})}
    end
  end

  defp page_title(:show), do: "Show Stats"
end
