defmodule ElevatedStats.SummonerApi do
  alias Plug.Parsers.JSON
  @base_url "https://na1.api.riotgames.com/lol/summoner/v4/summoners"

  def get_summoner_by_name(name) do
    url =
      name
      |> String.downcase()
      |> URI.encode()
      |> build_by_name_url

    {:ok, summoner_resp} =
      Finch.build(:get, url, [{"X-Riot-Token", System.get_env("RIOT_KEY")}])
      |> Finch.request(ElevatedStats.Finch)

    Jason.decode!(summoner_resp.body)
  end

  defp build_by_name_url(name) do
    @base_url <> "/by-name/" <> name
  end
end
