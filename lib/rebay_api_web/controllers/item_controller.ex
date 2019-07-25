defmodule RebayApiWeb.ItemController do
  use RebayApiWeb, :controller

  alias RebayApi.Accounts
  alias RebayApi.Listings
  alias RebayApi.Listings.Item

  action_fallback RebayApiWeb.FallbackController

  def index(conn, _params) do
    items = Listings.list_items()
    render(conn, "index.json", items: items)
  end

  def create(conn, %{"item" => item_params, "user_uuid" => user_uuid}) do
    user = Accounts.get_user!(user_uuid)
    with {:ok, %Item{} = item} <- Listings.create_item(Map.put(item_params, "user_id", user.id)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_item_path(conn, :show, user_uuid, item))
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
