defmodule UndiWeb.UserTwoFactorController do
  use UndiWeb, :controller

  import UndiWeb.UserAuth

  plug :fetch_current_user

  def new(conn, %{"token" => "" <> token}) do
    case Phoenix.Token.verify(UndiWeb.Endpoint, "2fa_confirmed", token, max_age: 120) do
      {:ok, _} ->
        user_return_to = get_session(conn, :user_return_to)

        conn
        |> put_session(:confirm_2fa_setup, "true")
        |> redirect(to: user_return_to || ~p"/")
      _ ->
        conn
        |> redirect(to: ~p"/")
    end
  end
end
