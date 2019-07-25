defmodule RebayApi.ItemTest do
  use RebayApi.DataCase

  alias RebayApi.Listings.Item
  alias RebayApi.TestHelpers

  setup do
    user = TestHelpers.user_fixture
    date = DateTime.utc_now() |> DateTime.truncate(:second)

    item = Repo.insert!(%Item{
      title: "test title 1",
      description: "test description 1",
      end_date: date,
      image: "test-image-url-1",
      price: 7500,
      category: "test category 1",
      user_id: user.id,
      uuid: Ecto.UUID.generate()})

    {:ok, item: item}
  end

  test "belongs to a user", context do
    item = Item
    |> Repo.get(context[:item].id)
    |> Repo.preload(:user)

    expected_user = item.user

    assert expected_user.first_name == "delete this user"
  end
end