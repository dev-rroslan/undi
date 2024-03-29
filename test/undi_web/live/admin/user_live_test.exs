defmodule UndiWeb.Admin.UserLiveTest do
  use UndiWeb.ConnCase

  import Phoenix.LiveViewTest
  import Undi.UsersFixtures

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  setup :register_and_log_in_admin

  describe "Index" do
    setup [:create_user]

    test "lists all users", %{conn: conn, user: user} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/users")

      assert html =~ "Listing Users"
      assert html =~ user.email
    end
  end

  describe "Show" do
    setup [:create_user]

    test "displays user", %{conn: conn, user: user} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/users/#{user}")

      assert html =~ "Show User"
      assert html =~ user.email
    end
  end
end
