defmodule RebayApiWeb.BidController do
  use RebayApiWeb, :controller

  alias RebayApi.UserItem
  alias RebayApi.UserItem.Bid

  action_fallback RebayApiWeb.FallbackController

  def index(conn, %{"item_uuid" => item_uuid}) do
    bids = UserItem.list_bids_by_item(item_uuid)
    render(conn, "index.json", bids: bids)
  end

  def index_by_user(conn, %{"user_uuid" => user_uuid}) do
    bids = UserItem.list_bids_by_user(user_uuid)
    render(conn, "index_by_user.json", bids: bids)
  end

  def create(conn, %{"bid" => bid_params, "item_uuid" => item_uuid}) do
    with {:ok, %Bid{} = bid} <- UserItem.create_bid(bid_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.item_bid_path(conn, :show, item_uuid, bid))
      |> render("show.json", bid: bid)
    end
  end

  def show(conn, %{"uuid" => uuid, "item_uuid" => item_uuid}) do
    bid = UserItem.get_bid!(uuid)
    render(conn, "show.json", bid: bid)
  end
end
