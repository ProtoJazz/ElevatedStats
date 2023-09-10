defmodule ElevatedStats.MatchApi do
  @base_url "https://americas.api.riotgames.com/lol/match/v5/matches"

  def get_match_by_id(id) do
    url = "#{@base_url}/#{id}"

    {:ok, match_resp} =
      Finch.build(:get, url, [{"X-Riot-Token", System.get_env("RIOT_KEY")}])
      |> Finch.request(ElevatedStats.Finch)

    Jason.decode!(match_resp.body)
  end

  def get_matches_for_summoner(puuid) do
    url = "#{@base_url}/by-puuid/#{puuid}/ids"

    {:ok, match_resp} =
      Finch.build(:get, url, [{"X-Riot-Token", System.get_env("RIOT_KEY")}])
      |> Finch.request(ElevatedStats.Finch)

    Jason.decode!(match_resp.body)
  end
end
