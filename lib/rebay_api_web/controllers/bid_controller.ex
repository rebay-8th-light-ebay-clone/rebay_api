defmodule RebayApiWeb.BidController do
  use RebayApiWeb, :controller

  alias RebayApi.UserItem
  alias RebayApi.UserItem.Bid

  action_fallback RebayApiWeb.FallbackController

  def index(conn, _params) do
    bids = UserItem.list_bids()
    render(conn, "index.json", bids: bids)
  end

  def create(conn, %{"bid" => bid_params}) do
    with {:ok, %Bid{} = bid} <- UserItem.create_bid(bid_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.bid_path(conn, :show, bid))
      |> render("show.json", bid: bid)
    end
  end

  def show(conn, %{"id" => id}) do
    bid = UserItem.get_bid!(id)
    render(conn, "show.json", bid: bid)
  end

  def update(conn, %{"id" => id, "bid" => bid_params}) do
    bid = UserItem.get_bid!(id)

    with {:ok, %Bid{} = bid} <- UserItem.update_bid(bid, bid_params) do
      render(conn, "show.json", bid: bid)
    end
  end

  def delete(conn, %{"id" => id}) do
    bid = UserItem.get_bid!(id)

    with {:ok, %Bid{}} <- UserItem.delete_bid(bid) do
      send_resp(conn, :no_content, "")
    end
  end
end
