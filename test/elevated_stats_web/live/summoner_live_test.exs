defmodule ElevatedStatsWeb.SummonerLiveTest do
  use ElevatedStatsWeb.ConnCase

  import Phoenix.LiveViewTest
  import ElevatedStats.SummonersFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_summoner(_) do
    summoner = summoner_fixture()
    %{summoner: summoner}
  end

  describe "Index" do
    setup [:create_summoner]

    test "lists all home", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/home")

      assert html =~ "Listing Home"
    end

    test "saves new summoner", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/home")

      assert index_live |> element("a", "New Summoner") |> render_click() =~
               "New Summoner"

      assert_patch(index_live, ~p"/home/new")

      assert index_live
             |> form("#summoner-form", summoner: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#summoner-form", summoner: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/home")

      html = render(index_live)
      assert html =~ "Summoner created successfully"
    end

    test "updates summoner in listing", %{conn: conn, summoner: summoner} do
      {:ok, index_live, _html} = live(conn, ~p"/home")

      assert index_live |> element("#home-#{summoner.id} a", "Edit") |> render_click() =~
               "Edit Summoner"

      assert_patch(index_live, ~p"/home/#{summoner}/edit")

      assert index_live
             |> form("#summoner-form", summoner: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#summoner-form", summoner: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/home")

      html = render(index_live)
      assert html =~ "Summoner updated successfully"
    end

    test "deletes summoner in listing", %{conn: conn, summoner: summoner} do
      {:ok, index_live, _html} = live(conn, ~p"/home")

      assert index_live |> element("#home-#{summoner.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#home-#{summoner.id}")
    end
  end

  describe "Show" do
    setup [:create_summoner]

    test "displays summoner", %{conn: conn, summoner: summoner} do
      {:ok, _show_live, html} = live(conn, ~p"/home/#{summoner}")

      assert html =~ "Show Summoner"
    end

    test "updates summoner within modal", %{conn: conn, summoner: summoner} do
      {:ok, show_live, _html} = live(conn, ~p"/home/#{summoner}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Summoner"

      assert_patch(show_live, ~p"/home/#{summoner}/show/edit")

      assert show_live
             |> form("#summoner-form", summoner: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#summoner-form", summoner: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/home/#{summoner}")

      html = render(show_live)
      assert html =~ "Summoner updated successfully"
    end
  end
end
