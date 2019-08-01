defmodule RebayApiWeb.ItemView do
  use RebayApiWeb, :view
  alias RebayApiWeb.ItemView
  alias RebayApi.Repo
  alias RebayApi.Listings.Item

  def render("index.json", %{items: items}) do
    %{data: render_many(items, ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    user_uuid = user_uuid(item.uuid)
    %{title: item.title,
      description: item.description,
      image: item.image,
      price: item.price,
      category: item.category,
      end_date: item.end_date,
      uuid: item.uuid,
      user_uuid: user_uuid}
  end

  defp user_uuid(uuid) do
    item = Item
    |> Repo.get_by!(uuid: uuid)
    |> Repo.preload(:user)

    item.user.uuid
  end
end
