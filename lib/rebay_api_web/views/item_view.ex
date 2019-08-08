defmodule RebayApiWeb.ItemView do
  use RebayApiWeb, :view
  alias RebayApiWeb.ItemView
  alias RebayApi.Repo
  alias RebayApi.Listings.Item
  alias RebayApi.UserItem

  def render("index.json", %{items: items}) do
    %{data: render_many(items, ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    user_uuid = user_uuid(item.uuid)
    highest_bid = highest_item_bid(item.uuid)
    %{title: item.title,
      description: item.description,
      image: item.image,
      price: item.price,
      category: item.category,
      end_date: item.end_date,
      uuid: item.uuid,
      user_uuid: user_uuid,
      current_highest_bid: highest_bid
    }
  end

  defp user_uuid(uuid) do
    item = Item
    |> Repo.get_by!(uuid: uuid)
    |> Repo.preload(:user)

    item.user.uuid
  end

  defp highest_item_bid(item_uuid) do
    item = Item
    |> Repo.get_by!(uuid: item_uuid)

    UserItem.get_highest_bid_price(item.id)
  end
end
