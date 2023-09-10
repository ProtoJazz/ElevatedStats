defmodule ElevatedStatsWeb.SummonerJSON do
  alias ElevatedStats.Users.Summoner

  @doc """
  Renders a list of summoners.
  """
  def index(%{summoners: summoners}) do
    %{data: for(summoner <- summoners, do: data(summoner))}
  end

  @doc """
  Renders a single summoner.
  """
  def show(%{summoner: summoner}) do
    %{data: data(summoner)}
  end

  defp data(%Summoner{} = summoner) do
    %{
      id: summoner.id,
      puuid: summoner.puuid,
      summoner_name: summoner.summoner_name,
      level: summoner.level,
      icon_id: summoner.icon_id
    }
  end
end
