defmodule RebayApi.Listings.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :category, :string
    field :description, :string
    field :end_date, :utc_datetime
    field :image, :string
    field :price, :integer
    field :title, :string
    field :uuid, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:title, :description, :image, :price, :category, :end_date, :uuid])
    |> validate_required([:title, :description, :image, :price, :category, :end_date, :uuid])
  end
end
