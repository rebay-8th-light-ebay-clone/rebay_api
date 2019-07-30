defmodule RebayApiWeb.ItemController do
  use RebayApiWeb, :controller

  alias RebayApi.Accounts
  alias RebayApi.Listings
  alias RebayApi.Listings.Item

  action_fallback RebayApiWeb.FallbackController

  plug :authenticate_session when action in [:create, :update, :delete]
  plug :authorize_user when action in [:create, :update, :delete]

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

  defp authenticate_session(conn, _) do
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

  defp authorize_user(conn, _) do
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
