defmodule RebayApi.UserItem.Bid do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias RebayApi.Repo
  alias RebayApi.Listings.Item
  alias RebayApi.Accounts.User
  alias RebayApi.UserItem.Bid

  schema "bids" do
    field :bid_price, :integer
    field :uuid, Ecto.UUID
    field :timestamp, :utc_datetime
    belongs_to :item, Item
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(bid, attrs) do
    bid
    |> cast(attrs, [:bid_price, :uuid, :item_id, :user_id, :timestamp])
    |> validate_required([:bid_price, :uuid, :item_id, :user_id])
    |> validate_price()
    |> validate_timestamp()
  end

  defp validate_price(changeset) do
    validate_change(changeset, :bid_price, fn :bid_price, bid_price ->
      item_id = get_field(changeset, :item_id)
      query = from bid in Bid, where: ^item_id == bid.item_id, order_by: [desc: bid.bid_price], limit: 1 
      highest_bid = Repo.one(query)

      cond do
        highest_bid && bid_price < highest_bid.bid_price + 1 ->
          [bid_price: "must be greater than previous bid by $1"]
        true -> 
          []
      end
    end)
  end

  defp validate_timestamp(changeset) do
    validate_change(changeset, :timestamp, fn :timestamp, timestamp ->
      item_id = get_field(changeset, :item_id)
      item_end_date = Repo.get!(Item, item_id).end_date

      case DateTime.compare(timestamp, item_end_date) do
        :gt ->
          [timestamp: "cannot be later than the end date of the item"]
        _ -> 
          []
      end
    end)
  end
end
