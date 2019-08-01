defmodule RebayApi.Listings do
  import Ecto.Query, warn: false
  alias RebayApi.Repo
  alias RebayApi.Listings.Item
  alias RebayApi.Accounts

  def list_items do
    Repo.all(Item)
  end

  def get_item!(uuid), do: Repo.get_by!(Item, uuid: uuid)

  def get_item_by_id!(id), do: Repo.get_by!(Item, id: id)

  def get_items_by_user(user_uuid) do
    fetchedUser = Accounts.get_user!(user_uuid)
    query = from item in Item, where: ^fetchedUser.id == item.user_id
    Repo.all(query, preload: [:user])
  end

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
    Item.shared_changeset(item, %{})
  end
end
