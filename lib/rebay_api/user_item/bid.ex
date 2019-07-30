defmodule RebayApi.UserItem.Bid do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bids" do
    field :bid_price, :integer
    field :user_uuid, :id
    field :item_uuid, :id

    timestamps()
  end

  @doc false
  def changeset(bid, attrs) do
    bid
    |> cast(attrs, [:bid_price])
    |> validate_required([:bid_price])
  end
end
