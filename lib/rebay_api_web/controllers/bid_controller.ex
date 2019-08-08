defmodule RebayApiWeb.BidController do
  use RebayApiWeb, :controller

  alias RebayApi.UserItem
  alias RebayApi.UserItem.Bid
  alias RebayApi.Listings
  alias RebayApi.Repo

  action_fallback RebayApiWeb.FallbackController

  plug RebayApiWeb.Plugs.AuthenticateSession when action in [:index_by_user, :create]
  plug RebayApiWeb.Plugs.AuthorizeUser when action in [:index_by_user]
  plug :authorize_change when action in [:create]

  def index_by_item(conn, %{"item_uuid" => item_uuid}) do
    bids = UserItem.list_bids_by_item(item_uuid)
    render(conn, "index_by_item.json", bids: bids)
  end

  def index_by_user(conn, %{"user_uuid" => user_uuid}) do
    bids = UserItem.list_bids_by_user(user_uuid)
    render(conn, "index_by_user.json", bids: bids)
  end

  def create(conn, params) do
    item = Listings.get_item!(params["item_uuid"])
    user = conn.assigns[:user]

    bid_params = params
    |> Map.put("user_id", user.id)
    |> Map.put("item_id", item.id)
    |> Map.put("uuid", Ecto.UUID.generate())

    with {:ok, %Bid{} = bid} <- UserItem.create_bid(bid_params) do
      handle_auto_bids(item.id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.item_bid_path(conn, :show, item.uuid, bid))
      |> render("show.json", bid: bid)
    end
  end

  defp handle_auto_bids(item_id) do
    item_id
    |> UserItem.get_auto_bids_by_item
    |> run_auto_bids(item_id)

    case length(item_id |> UserItem.get_auto_bids_by_item) do
      0 -> nil
      1 -> nil
      _ -> handle_auto_bids(item_id)
    end
  end

  defp run_auto_bids(bids, item_id) do
    bids
    |> Enum.each(fn bid ->
      last_bidders_id = UserItem.get_highest_bidder_user_id(item_id)
      price_increment = 100
      next_bid_price = UserItem.get_highest_bid_price(item_id) + price_increment
      if bid.max_bid_price >= next_bid_price && bid.user_id != last_bidders_id do
        new_bid = %{
          user_id: bid.user_id,
          item_id: item_id,
          bid_price: next_bid_price,
          uuid: Ecto.UUID.generate()
        }
        UserItem.create_bid(new_bid)
      end
    end)
  end

  def show(conn, %{"uuid" => uuid}) do
    bid = UserItem.get_bid!(uuid)
    render(conn, "show.json", bid: bid)
  end

  defp authorize_change(conn, _params) do
    item = conn.params["item_uuid"]
    |> Listings.get_item!
    |> Repo.preload(:user)

    user = conn.assigns[:user]

    if user.id != item.user.id do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> put_view(RebayApiWeb.ErrorView)
      |> render("403.json")
      |> halt()
    end
  end
end
