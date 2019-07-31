defmodule RebayApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias RebayApi.Listings.Item
  alias RebayApi.UserItem.Bid

  schema "users" do
    field :avatar, :string
    field :email, :string
    field :first_name, :string
    field :provider, :string
    field :uuid, Ecto.UUID
    has_many :items, Item
    has_many :bids, Bid

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :provider, :avatar, :first_name, :uuid])
    |> validate_required([:email, :provider, :avatar, :first_name, :uuid])
  end
end
