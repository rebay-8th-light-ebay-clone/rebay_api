defmodule RebayApi.UserItem do
  import Ecto.Query, warn: false
  alias RebayApi.Repo
  alias RebayApi.UserItem.Bid
  alias RebayApi.Listings
  alias RebayApi.Accounts

  def list_bids do
    Repo.all(Bid)
  end

  def get_highest_bid_price(item_id) do
    bid = get_highest_bid(item_id)
    if (bid), do: bid.bid_price
  end

  def get_highest_bidder_user_id(item_id) do
    bid = get_highest_bid(item_id)
    if (bid), do: bid.user_id
  end

  defp get_highest_bid(item_id) do
    query = from bid in Bid, where: ^item_id == bid.item_id, order_by: [desc: bid.bid_price], limit: 1
    Repo.one(query)
  end

  def list_bids_by_item(item_uuid) do
    bidItem = Listings.get_item!(item_uuid)
    query = from bid in Bid, where: ^bidItem.id == bid.item_id
    Repo.all(query, preload: [:item])
  end

  def list_bids_by_user(user_uuid) do
    bidUser = Accounts.get_user!(user_uuid)
    user_item_ids = user_item_ids_query(bidUser.id) |> get_all_bids_by
    get_users_bids_by_items(user_item_ids, bidUser.id)
  end

  def get_auto_bids_by_item(item_id) do
    item_highest_bid = get_highest_bid_price(item_id)
    query = from bid in Bid,
              where: ^item_id == bid.item_id and not is_nil(bid.max_bid_price) and bid.max_bid_price > ^item_highest_bid,
              order_by: [desc: bid.updated_at]
    Repo.all(query, preload: [:bid])
  end

  defp get_users_bids_by_items(user_item_ids, user_id) do
    Enum.reduce user_item_ids, [], fn (item_id, acc) ->
      item_bid = %{}
      |> Map.put(:item, Listings.get_item_by_id!(item_id))
      |> Map.put(:bids, user_item_bids_query(user_id, item_id) |> get_all_bids_by)

      acc ++ [item_bid]
    end
  end

  defp user_item_ids_query(user_id) do
   from bid in Bid, where: ^user_id == bid.user_id, select: bid.item_id, distinct: bid.item_id
  end

  defp user_item_bids_query(user_id, item_id) do
    from bid in Bid, where: ^user_id == bid.user_id and ^item_id == bid.item_id, select: bid
  end

  defp get_all_bids_by(query) do
    Repo.all(query, preload: [:user, :item])
  end

  def get_bid!(uuid), do: Repo.get_by!(Bid, uuid: uuid)

  def create_bid(attrs \\ %{}) do
    %Bid{}
    |> Bid.changeset(attrs)
    |> Repo.insert()
  end

  def delete_bid(%Bid{} = bid) do
    Repo.delete(bid)
  end

  def change_bid(%Bid{} = bid) do
    Bid.changeset(bid, %{})
  end
end
