defmodule ElevatedStatsWeb.MatchJSON do
  alias ElevatedStats.Matches.Match

  @doc """
  Renders a list of matches.
  """
  def index(%{matches: matches}) do
    %{data: for(match <- matches, do: data(match))}
  end

  @doc """
  Renders a single match.
  """
  def show(%{match: match}) do
    %{data: data(match)}
  end

  defp data(%Match{} = match) do
    %{
      id: match.id,
      match_time: match.match_time,
      queue_id: match.queue_id
    }
  end
end
