defmodule UndiWeb.Live.CommandPaletteLiveTest do
  use UndiWeb.ConnCase

  import Phoenix.LiveViewTest
  alias UndiWeb.Live.CommandPaletteLive

  describe "command palette" do
    test "displays modal when its given the show-event", %{conn: conn} do
      {:ok, view, html} =
        live_isolated(conn, CommandPaletteLive, id: "command-palette-lv")

      assert html =~ "id=\"command-palette\""
      refute html =~ "Search pages and records"

      assert render_hook(view, :show, %{}) =~ "Search pages and records"
    end
  end
end
