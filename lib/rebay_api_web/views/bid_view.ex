defmodule RebayApiWeb.BidView do
  use RebayApiWeb, :view
  alias RebayApiWeb.BidView
  alias RebayApi.Repo
  alias RebayApi.UserItem
  alias RebayApiWeb.ItemView

  def render("index_by_item.json", %{bids: bids}) do
    %{data: render_many(bids, BidView, "bid.json")}
  end

  def render("index_by_user.json", %{bids: bids}) do
    %{data: render_many(bids, BidView, "user_item_bid.json")}
  end

  def render("show.json", %{bid: bid}) do
    %{data: render_one(bid, BidView, "bid.json")}
  end

  def render("bid.json", %{bid: bid}) do
    %{ "item_uuid" => item_uuid, "user_uuid" => user_uuid } = item_user_uuid(bid.uuid)
    %{
      bid_price: bid.bid_price,
      uuid: bid.uuid,
      item_uuid: item_uuid,
      user_uuid: user_uuid,
      timestamp: bid.inserted_at
    }
  end

  def render("user_item_bid.json", %{bid: bid}) do
    %{
      item: render_one(bid.item, ItemView, "item.json"),
      bids: render_many(bid.bids, BidView, "bid.json"),
    }
  end

  defp item_user_uuid(uuid) do
    bid = UserItem.get_bid!(uuid) |> Repo.preload(:item) |> Repo.preload(:user)
    %{
      "item_uuid" => bid.item.uuid,
      "user_uuid" => bid.user.uuid
    }
  end
end
