defmodule RebayApi.UserTest do
  use RebayApi.DataCase

  alias RebayApi.Accounts.User
  alias RebayApi.Listings.Item
  alias RebayApi.TestHelpers

  setup do
    user = TestHelpers.user_fixture
    date = DateTime.utc_now() |> DateTime.truncate(:second)
    Repo.insert!(%Item{
      title: "test title 1",
      description: "test description 1",
      end_date: date,
      image: "test-image-url-1",
      price: 7500,
      category: "test category 1",
      user_id: user.id,
      uuid: Ecto.UUID.generate()})
    Repo.insert!(%Item{
      title: "test title 2",
      description: "test description 2",
      end_date: date,
      image: "test-image-url-2",
      price: 500,
      category: "test category 2",
      user_id: user.id,
      uuid: Ecto.UUID.generate()})

      {:ok, user: user}
  end

  test "has many items", context do
    user = User
    |> Repo.get(context[:user].id)
    |> Repo.preload(:items)

    assert Enum.count(user.items) == 2
  end
end