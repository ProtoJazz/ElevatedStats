defmodule ElevatedStatsWeb.StatsLiveTest do
  use ElevatedStatsWeb.ConnCase

  import Phoenix.LiveViewTest
  import ElevatedStats.SummonersFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_stats(_) do
    stats = stats_fixture()
    %{stats: stats}
  end

  describe "Index" do
    setup [:create_stats]

    test "lists all show", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/show")

      assert html =~ "Listing Show"
    end

    test "saves new stats", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/show")

      assert index_live |> element("a", "New Stats") |> render_click() =~
               "New Stats"

      assert_patch(index_live, ~p"/show/new")

      assert index_live
             |> form("#stats-form", stats: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#stats-form", stats: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/show")

      html = render(index_live)
      assert html =~ "Stats created successfully"
    end

    test "updates stats in listing", %{conn: conn, stats: stats} do
      {:ok, index_live, _html} = live(conn, ~p"/show")

      assert index_live |> element("#show-#{stats.id} a", "Edit") |> render_click() =~
               "Edit Stats"

      assert_patch(index_live, ~p"/show/#{stats}/edit")

      assert index_live
             |> form("#stats-form", stats: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#stats-form", stats: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/show")

      html = render(index_live)
      assert html =~ "Stats updated successfully"
    end

    test "deletes stats in listing", %{conn: conn, stats: stats} do
      {:ok, index_live, _html} = live(conn, ~p"/show")

      assert index_live |> element("#show-#{stats.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#show-#{stats.id}")
    end
  end

  describe "Show" do
    setup [:create_stats]

    test "displays stats", %{conn: conn, stats: stats} do
      {:ok, _show_live, html} = live(conn, ~p"/show/#{stats}")

      assert html =~ "Show Stats"
    end

    test "updates stats within modal", %{conn: conn, stats: stats} do
      {:ok, show_live, _html} = live(conn, ~p"/show/#{stats}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Stats"

      assert_patch(show_live, ~p"/show/#{stats}/show/edit")

      assert show_live
             |> form("#stats-form", stats: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#stats-form", stats: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/show/#{stats}")

      html = render(show_live)
      assert html =~ "Stats updated successfully"
    end
  end
end
