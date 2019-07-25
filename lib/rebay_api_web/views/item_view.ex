defmodule RebayApiWeb.ItemView do
  use RebayApiWeb, :view
  alias RebayApiWeb.ItemView
  alias RebayApi.Repo

  def render("index.json", %{items: items}) do
    %{data: render_many(items, ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{title: item.title,
      description: item.description,
      image: item.image,
      price: item.price,
      category: item.category,
      end_date: item.end_date,
      uuid: item.uuid,}
  end
end
