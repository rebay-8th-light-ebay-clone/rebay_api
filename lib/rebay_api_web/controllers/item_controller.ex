defmodule RebayApiWeb.ItemController do
  use RebayApiWeb, :controller

  alias RebayApi.Accounts
  alias RebayApi.Listings
  alias RebayApi.Listings.Item

  action_fallback RebayApiWeb.FallbackController

  plug RebayApiWeb.Plugs.AuthenticateSession when action in [:create, :update, :delete]
  plug RebayApiWeb.Plugs.AuthorizeUser when action in [:create, :update, :delete]

  def index(conn, _params) do
    items = Listings.list_items()
    render(conn, "index.json", items: items)
  end

  def create(conn, _params) do
    user = conn.params["user_uuid"] |> Accounts.get_user!()

    create_attrs = Map.put(conn.params, "user_id", user.id)
    |> Map.put("uuid", Ecto.UUID.generate)

    with {:ok, %Item{} = item} <- Listings.create_item(create_attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_item_path(conn, :show, user.uuid, item))
      |> render("show.json", item: item)
    end
  end

  def show(conn, %{"uuid" => uuid, "user_uuid" => _user_uuid}) do
    item = Listings.get_item!(uuid)
    render(conn, "show.json", item: item)
  end

  def update(conn, %{"uuid" => uuid, "item" => item_params}) do
    item = Listings.get_item!(uuid)

    with {:ok, %Item{} = item} <- Listings.update_item(item, item_params) do
      render(conn, "show.json", item: item)
    end
  end

  def delete(conn, %{"uuid" => uuid, "user_uuid" => _user_uuid}) do
    item = Listings.get_item!(uuid)

    with {:ok, %Item{}} <- Listings.delete_item(item) do
      send_resp(conn, :no_content, "")
    end
  end
end
