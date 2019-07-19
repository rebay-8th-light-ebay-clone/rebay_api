defmodule RebayApiWeb.ItemsController do
  use RebayApiWeb, :controller

  def index(conn, _params) do
    json(conn, %{items: [
      %{
        title: "Storage Bench",
        description: "48 inch x 16 inch bench",
        price: "$50"
      }
    ]})
  end

end
