defmodule RebayApiWeb.Plugs.AuthorizeUser do
  import Plug.Conn
  use RebayApiWeb, :controller

  def init(_params) do
  end

  def call(conn, _params) do
    user_uuid_param = conn.params["user_uuid"]
    current_user = conn.assigns[:user]

    if current_user != nil && user_uuid_param == current_user.uuid do
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
