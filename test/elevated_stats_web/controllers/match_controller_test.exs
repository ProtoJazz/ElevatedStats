defmodule ElevatedStatsWeb.MatchControllerTest do
  use ElevatedStatsWeb.ConnCase

  import ElevatedStats.MatchesFixtures

  alias ElevatedStats.Matches.Match

  @create_attrs %{
    match_time: ~U[2023-09-15 00:30:00Z],
    queue_id: 42
  }
  @update_attrs %{
    match_time: ~U[2023-09-16 00:30:00Z],
    queue_id: 43
  }
  @invalid_attrs %{match_time: nil, queue_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all matches", %{conn: conn} do
      conn = get(conn, ~p"/api/matches")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create match" do
    test "renders match when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/matches", match: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/matches/#{id}")

      assert %{
               "id" => ^id,
               "match_time" => "2023-09-15T00:30:00Z",
               "queue_id" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/matches", match: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update match" do
    setup [:create_match]

    test "renders match when data is valid", %{conn: conn, match: %Match{id: id} = match} do
      conn = put(conn, ~p"/api/matches/#{match}", match: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/matches/#{id}")

      assert %{
               "id" => ^id,
               "match_time" => "2023-09-16T00:30:00Z",
               "queue_id" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, match: match} do
      conn = put(conn, ~p"/api/matches/#{match}", match: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete match" do
    setup [:create_match]

    test "deletes chosen match", %{conn: conn, match: match} do
      conn = delete(conn, ~p"/api/matches/#{match}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/matches/#{match}")
      end
    end
  end

  defp create_match(_) do
    match = match_fixture()
    %{match: match}
  end
end
