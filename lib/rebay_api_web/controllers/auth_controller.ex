defmodule RebayApiWeb.AuthController do
  use RebayApiWeb, :controller

  action_fallback RebayApiWeb.FallbackController

  def request(conn, _params) do
    conn
  end

  def callback(conn, _params) do
    conn
  end
end
