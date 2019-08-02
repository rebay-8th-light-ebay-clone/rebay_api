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
  end

  defp validate_price(changeset) do
    validate_change(changeset, :bid_price, fn :bid_price, bid_price ->
      item_id = get_field(changeset, :item_id)
      query = from bid in Bid, where: ^item_id == bid.item_id, order_by: [desc: bid.bid_price], limit: 1 
      highest_bid = List.first(Repo.all(query))

      cond do
        highest_bid && bid_price < highest_bid.bid_price + 1 ->
          [bid_price: "must be greater than previous bid by $1"]
        true -> 
          []
      end
    end)
  end
end
