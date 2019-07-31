defmodule RebayApi.BidTest do
  use RebayApi.DataCase

  alias RebayApi.UserItem.Bid
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

    bid = TestHelpers.bid_fixture(%{ user_id: user.id, item_id: item.id })

    {:ok, bid: bid}
  end

  test "belongs to a user", context do
    bid = Bid
    |> Repo.get(context[:bid].id)
    |> Repo.preload(:user)

    expected_user = bid.user

    assert expected_user.first_name == "delete this user"
  end

  test "belongs to a item", context do
    bid = Bid
    |> Repo.get(context[:bid].id)
    |> Repo.preload(:item)

    expected_item = bid.item

    assert expected_item.title == "test title 1"
  end
end
