defmodule RebayApiWeb.ItemController do
  use RebayApiWeb, :controller

  alias RebayApi.Accounts
  alias RebayApi.Listings
  alias RebayApi.Listings.Item
  alias RebayApi.Repo

  action_fallback RebayApiWeb.FallbackController

  plug RebayApiWeb.Plugs.AuthenticateSession when action in [:create, :update, :delete]
  plug RebayApiWeb.Plugs.AuthorizeUser when action in [:create, :update, :delete]
  plug :authorize_change when action in [:update, :delete]

  def index(conn, _params) do
    items = Listings.list_items()
    render(conn, "index.json", items: items)
  end
  
  def index_by_user(conn, %{"user_uuid" => user_uuid}) do
    user_items = Listings.get_items_by_user(user_uuid)
    render(conn, "index.json", items: user_items)
  end

  def create(conn, params) do
    user = params["user_uuid"] |> Accounts.get_user!()

    create_attrs = Map.put(params, "user_id", user.id)
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

  def update(conn, params) do
    item = Listings.get_item!(params["uuid"])

    with {:ok, %Item{} = item} <- Listings.update_item(item, params) do
      render(conn, "show.json", item: item)
    end
  end

  def delete(conn, %{"uuid" => uuid, "user_uuid" => _user_uuid}) do
    item = Listings.get_item!(uuid)

    with {:ok, %Item{}} <- Listings.delete_item(item) do
      send_resp(conn, :no_content, "")
    end
  end

  defp authorize_change(conn, _params) do
    user_uuid = conn.params["user_uuid"]
    item = Listings.get_item!(conn.params["uuid"])
    |> Repo.preload(:user)

    if user_uuid == item.user.uuid do
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
