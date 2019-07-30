defmodule RebayApi.Listings do
  import Ecto.Query, warn: false
  alias RebayApi.Repo

  alias RebayApi.Listings.Item

  def list_items do
    Repo.all(Item)
  end

  def get_item!(uuid), do: Repo.get_by!(Item, uuid: uuid)

  def get_item_by_id!(id), do: Repo.get_by!(Item, id: id)

  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  def change_item(%Item{} = item) do
    Item.changeset(item, %{})
  end
end
