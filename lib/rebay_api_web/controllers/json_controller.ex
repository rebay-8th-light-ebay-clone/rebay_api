defmodule RebayApiWeb.JSONController do
  use RebayApiWeb, :controller

  def index(conn, _params) do
    json(conn, %{foo: "bar"})
  end

end
