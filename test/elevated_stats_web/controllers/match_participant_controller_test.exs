defmodule ElevatedStatsWeb.MatchParticipantControllerTest do
  use ElevatedStatsWeb.ConnCase

  import ElevatedStats.MatchesFixtures

  alias ElevatedStats.Matches.MatchParticipant

  @create_attrs %{
    champion_icon_id: 42,
    champion_name: "some champion_name",
    damage_dealt_to_turrets: 42,
    damage_per_gold: 120.5,
    gold_earned: 120.5,
    match_id: "some match_id",
    match_time: ~U[2023-09-15 00:36:00Z],
    queue_id: 42,
    summoner_id: "some summoner_id",
    win: true
  }
  @update_attrs %{
    champion_icon_id: 43,
    champion_name: "some updated champion_name",
    damage_dealt_to_turrets: 43,
    damage_per_gold: 456.7,
    gold_earned: 456.7,
    match_id: "some updated match_id",
    match_time: ~U[2023-09-16 00:36:00Z],
    queue_id: 43,
    summoner_id: "some updated summoner_id",
    win: false
  }
  @invalid_attrs %{champion_icon_id: nil, champion_name: nil, damage_dealt_to_turrets: nil, damage_per_gold: nil, gold_earned: nil, match_id: nil, match_time: nil, queue_id: nil, summoner_id: nil, win: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all match_participants", %{conn: conn} do
      conn = get(conn, ~p"/api/match_participants")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create match_participant" do
    test "renders match_participant when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/match_participants", match_participant: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/match_participants/#{id}")

      assert %{
               "id" => ^id,
               "champion_icon_id" => 42,
               "champion_name" => "some champion_name",
               "damage_dealt_to_turrets" => 42,
               "damage_per_gold" => 120.5,
               "gold_earned" => 120.5,
               "match_id" => "some match_id",
               "match_time" => "2023-09-15T00:36:00Z",
               "queue_id" => 42,
               "summoner_id" => "some summoner_id",
               "win" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/match_participants", match_participant: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update match_participant" do
    setup [:create_match_participant]

    test "renders match_participant when data is valid", %{conn: conn, match_participant: %MatchParticipant{id: id} = match_participant} do
      conn = put(conn, ~p"/api/match_participants/#{match_participant}", match_participant: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/match_participants/#{id}")

      assert %{
               "id" => ^id,
               "champion_icon_id" => 43,
               "champion_name" => "some updated champion_name",
               "damage_dealt_to_turrets" => 43,
               "damage_per_gold" => 456.7,
               "gold_earned" => 456.7,
               "match_id" => "some updated match_id",
               "match_time" => "2023-09-16T00:36:00Z",
               "queue_id" => 43,
               "summoner_id" => "some updated summoner_id",
               "win" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, match_participant: match_participant} do
      conn = put(conn, ~p"/api/match_participants/#{match_participant}", match_participant: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete match_participant" do
    setup [:create_match_participant]

    test "deletes chosen match_participant", %{conn: conn, match_participant: match_participant} do
      conn = delete(conn, ~p"/api/match_participants/#{match_participant}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/match_participants/#{match_participant}")
      end
    end
  end

  defp create_match_participant(_) do
    match_participant = match_participant_fixture()
    %{match_participant: match_participant}
  end
end
