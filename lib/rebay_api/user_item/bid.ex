defmodule RebayApi.UserItem.Bid do
  use Ecto.Schema
  import Ecto.Changeset
  alias RebayApi.Listings.Item
  alias RebayApi.Accounts.User

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
    |> validate_required([:bid_price, :uuid])
  end
end
