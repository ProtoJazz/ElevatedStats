defmodule ElevatedStatsWeb.SummonerController do
  use ElevatedStatsWeb, :controller

  alias ElevatedStats.Users
  alias ElevatedStats.Users.Summoner

  action_fallback ElevatedStatsWeb.FallbackController

  def index(conn, _params) do
    summoners = Users.list_summoners()
    render(conn, :index, summoners: summoners)
  end

  def create(conn, %{"summoner" => summoner_params}) do
    with {:ok, %Summoner{} = summoner} <- Users.create_summoner(summoner_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/summoners/#{summoner}")
      |> render(:show, summoner: summoner)
    end
  end

  def show(conn, %{"id" => id}) do
    summoner = Users.get_summoner!(id)
    render(conn, :show, summoner: summoner)
  end

  def update(conn, %{"id" => id, "summoner" => summoner_params}) do
    summoner = Users.get_summoner!(id)

    with {:ok, %Summoner{} = summoner} <- Users.update_summoner(summoner, summoner_params) do
      render(conn, :show, summoner: summoner)
    end
  end

  def delete(conn, %{"id" => id}) do
    summoner = Users.get_summoner!(id)

    with {:ok, %Summoner{}} <- Users.delete_summoner(summoner) do
      send_resp(conn, :no_content, "")
    end
  end
end
