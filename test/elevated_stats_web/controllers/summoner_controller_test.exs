defmodule ElevatedStatsWeb.SummonerControllerTest do
  use ElevatedStatsWeb.ConnCase

  import ElevatedStats.UsersFixtures

  alias ElevatedStats.Users.Summoner

  @create_attrs %{
    icon_id: 42,
    level: 42,
    puuid: "some puuid",
    summoner_name: "some summoner_name"
  }
  @update_attrs %{
    icon_id: 43,
    level: 43,
    puuid: "some updated puuid",
    summoner_name: "some updated summoner_name"
  }
  @invalid_attrs %{icon_id: nil, level: nil, puuid: nil, summoner_name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all summoners", %{conn: conn} do
      conn = get(conn, ~p"/api/summoners")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create summoner" do
    test "renders summoner when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/summoners", summoner: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/summoners/#{id}")

      assert %{
               "id" => ^id,
               "icon_id" => 42,
               "level" => 42,
               "puuid" => "some puuid",
               "summoner_name" => "some summoner_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/summoners", summoner: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update summoner" do
    setup [:create_summoner]

    test "renders summoner when data is valid", %{conn: conn, summoner: %Summoner{id: id} = summoner} do
      conn = put(conn, ~p"/api/summoners/#{summoner}", summoner: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/summoners/#{id}")

      assert %{
               "id" => ^id,
               "icon_id" => 43,
               "level" => 43,
               "puuid" => "some updated puuid",
               "summoner_name" => "some updated summoner_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, summoner: summoner} do
      conn = put(conn, ~p"/api/summoners/#{summoner}", summoner: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete summoner" do
    setup [:create_summoner]

    test "deletes chosen summoner", %{conn: conn, summoner: summoner} do
      conn = delete(conn, ~p"/api/summoners/#{summoner}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/summoners/#{summoner}")
      end
    end
  end

  defp create_summoner(_) do
    summoner = summoner_fixture()
    %{summoner: summoner}
  end
end
