defmodule RebayApiWeb.BidView do
  use RebayApiWeb, :view
  alias RebayApiWeb.BidView

  def render("index.json", %{bids: bids}) do
    %{data: render_many(bids, BidView, "bid.json")}
  end

  def render("show.json", %{bid: bid}) do
    %{data: render_one(bid, BidView, "bid.json")}
  end

  def render("bid.json", %{bid: bid}) do
    %{id: bid.id,
      bid_price: bid.bid_price}
  end
end
