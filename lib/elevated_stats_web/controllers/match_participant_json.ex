defmodule ElevatedStatsWeb.MatchParticipantJSON do
  alias ElevatedStats.Matches.MatchParticipant

  @doc """
  Renders a list of match_participants.
  """
  def index(%{match_participants: match_participants}) do
    %{data: for(match_participant <- match_participants, do: data(match_participant))}
  end

  @doc """
  Renders a single match_participant.
  """
  def show(%{match_participant: match_participant}) do
    %{data: data(match_participant)}
  end

  defp data(%MatchParticipant{} = match_participant) do
    %{
      id: match_participant.id,
      queue_id: match_participant.queue_id,
      damage_dealt_to_turrets: match_participant.damage_dealt_to_turrets,
      match_time: match_participant.match_time,
      gold_earned: match_participant.gold_earned,
      champion_name: match_participant.champion_name,
      champion_icon_id: match_participant.champion_icon_id,
      win: match_participant.win,
      summoner_id: match_participant.summoner_id,
      match_id: match_participant.match_id,
      damage_per_gold: match_participant.damage_per_gold
    }
  end
end
