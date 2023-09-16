defmodule ElevatedStatsWeb.MatchParticipantController do
  use ElevatedStatsWeb, :controller

  alias ElevatedStats.Matches
  alias ElevatedStats.Matches.MatchParticipant

  action_fallback ElevatedStatsWeb.FallbackController

  def index(conn, _params) do
    match_participants = Matches.list_match_participants()
    render(conn, :index, match_participants: match_participants)
  end

  def create(conn, %{"match_participant" => match_participant_params}) do
    with {:ok, %MatchParticipant{} = match_participant} <- Matches.create_match_participant(match_participant_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/match_participants/#{match_participant}")
      |> render(:show, match_participant: match_participant)
    end
  end

  def show(conn, %{"id" => id}) do
    match_participant = Matches.get_match_participant!(id)
    render(conn, :show, match_participant: match_participant)
  end

  def update(conn, %{"id" => id, "match_participant" => match_participant_params}) do
    match_participant = Matches.get_match_participant!(id)

    with {:ok, %MatchParticipant{} = match_participant} <- Matches.update_match_participant(match_participant, match_participant_params) do
      render(conn, :show, match_participant: match_participant)
    end
  end

  def delete(conn, %{"id" => id}) do
    match_participant = Matches.get_match_participant!(id)

    with {:ok, %MatchParticipant{}} <- Matches.delete_match_participant(match_participant) do
      send_resp(conn, :no_content, "")
    end
  end
end
