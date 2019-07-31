defmodule RebayApiWeb.Plugs.AuthenticateSession do
  import Plug.Conn
  use RebayApiWeb, :controller

  def init(_params) do
  end

  def call(conn, _params) do
    conn = fetch_cookies(conn, [:session_id])
    session_cookie = conn.cookies["session_id"]
    session_id = get_session(conn, :id)

    if conn.assigns[:user] && session_cookie == session_id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(RebayApiWeb.ErrorView)
      |> render("401.json")
      |> halt()
    end
  end
end
