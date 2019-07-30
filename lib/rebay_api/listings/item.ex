defmodule RebayApi.Listings.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias RebayApi.Accounts.User

  schema "items" do
    field :category, :string
    field :description, :string
    field :end_date, :utc_datetime
    field :image, :string
    field :price, :integer
    field :title, :string
    field :uuid, Ecto.UUID
    belongs_to :user, User

    timestamps()
  end

  def changeset(item, attrs) do
    item
    |> cast(attrs, [:title, :description, :image, :price, :category, :end_date, :uuid, :user_id])
    |> validate_required([:title, :description, :image, :price, :category, :end_date, :uuid])
    |> validate_end_date()
    |> validate_price()
  end

  def validate_end_date(changeset) do
    validate_change(changeset, :end_date, fn :end_date, end_date ->
      {:ok, current_date} = DateTime.now("Etc/UTC")
      case DateTime.compare(end_date, current_date) do
        :lt ->
          [end_date: "cannot be in the past"]
        _ -> 
          []
      end
    end)
  end

  def validate_price(changeset) do
    validate_change(changeset, :price, fn :price, price ->
      cond do
        price < 100 ->
          [price: "cannot be less than $1"]
        true -> 
          []
      end
    end)
  end
end
