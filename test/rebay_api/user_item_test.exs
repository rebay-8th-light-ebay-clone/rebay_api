defmodule RebayApi.UserItemTest do
  use RebayApi.DataCase

  alias RebayApi.UserItem
  alias RebayApi.TestHelpers
  alias RebayApi.UserItem.Bid

  describe "bids" do
    @user_uuid Ecto.UUID.generate()
    @item_uuid Ecto.UUID.generate()
    @item_id 10
    @invalid_attrs %{bid_price: nil, item_id: nil, user_id: nil, uuid: nil}

    def many_bids_fixture() do
      user = TestHelpers.user_fixture(%{uuid: @user_uuid})
      item1 = TestHelpers.item_fixture(%{
        title: "item 1 title",
        user_id: user.id,
        end_date: "2020-08-31T06:59:59Z",
        uuid: @item_uuid,
        id: @item_id
      })
      item2 = TestHelpers.item_fixture(%{
        title: "item 2 title",
        user_id: user.id,
        end_date: "2020-08-31T06:59:59Z"
      })
      bid1 = TestHelpers.bid_fixture(%{
        bid_price: 1,
        user_id: user.id,
        item_id: item1.id
      })
      bid2 = TestHelpers.bid_fixture(%{
        bid_price: 2,
        user_id: user.id,
        item_id: item1.id
      })
      bid3 = TestHelpers.bid_fixture(%{
        bid_price: 3,
        user_id: user.id,
        item_id: item2.id
      })
      bid4 = TestHelpers.bid_fixture(%{
        bid_price: 4,
        user_id: user.id,
        item_id: item2.id
      })
      [bid1, bid2, bid3, bid4]
    end

    test "get_highest_bid_price/1 returns max bid number" do
      user = TestHelpers.user_fixture()
      item = TestHelpers.item_fixture(%{user_id: user.id})

      UserItem.create_bid(%{bid_price: 43, uuid: Ecto.UUID.generate(), user_id: user.id, item_id: item.id})
      UserItem.create_bid(%{bid_price: 44, uuid: Ecto.UUID.generate(), user_id: user.id, item_id: item.id})
      UserItem.create_bid(%{bid_price: 45, uuid: Ecto.UUID.generate(), user_id: user.id, item_id: item.id})
      highestBid = UserItem.get_highest_bid_price(item.id);
      assert highestBid == 45
    end

    test "get_highest_bid_price/1 returns nil when there are no bids" do
      user = TestHelpers.user_fixture()
      item = TestHelpers.item_fixture(%{user_id: user.id})

      highestBid = UserItem.get_highest_bid_price(item.id);
      assert highestBid == nil
    end

    test "get_highest_bidder_user_id/1 returns max bid number" do
      user = TestHelpers.user_fixture()
      item = TestHelpers.item_fixture(%{user_id: user.id})

      UserItem.create_bid(%{bid_price: 43, uuid: Ecto.UUID.generate(), user_id: user.id, item_id: item.id})
      UserItem.create_bid(%{bid_price: 44, uuid: Ecto.UUID.generate(), user_id: user.id, item_id: item.id})
      UserItem.create_bid(%{bid_price: 45, uuid: Ecto.UUID.generate(), user_id: user.id, item_id: item.id})
      user_id = UserItem.get_highest_bidder_user_id(item.id);
      assert user_id == user.id
    end

    test "get_auto_bids_by_item/1 returns the current auto bids for a given item uuid" do
      item = TestHelpers.item_fixture(%{ price: 100 })
      _bid1 = TestHelpers.bid_fixture(%{ max_bid_price: 500, bid_price: 200, item_id: item.id })
      bid2 = TestHelpers.bid_fixture(%{ max_bid_price: 700, bid_price: 300, item_id: item.id })
      _bid3 = TestHelpers.bid_fixture(%{ max_bid_price: 500, bid_price: 400, item_id: item.id })
      _bid4 = TestHelpers.bid_fixture(%{ bid_price: 500, item_id: item.id })
      bid5 = TestHelpers.bid_fixture(%{ max_bid_price: 800, bid_price: 600, item_id: item.id })

      item2 = TestHelpers.item_fixture()
      _bid6 = TestHelpers.bid_fixture(%{ max_bid_price: 30, bid_price: 25, item_id: item2.id })

      assert UserItem.get_auto_bids_by_item(item.id) == [bid2, bid5]
    end

    test "list_bids/0 returns all bids" do
      bid = TestHelpers.bid_fixture()
      assert UserItem.list_bids() == [bid]
    end

    test "get_bid!/1 returns the bid with given id" do
      bid = TestHelpers.bid_fixture()
      assert UserItem.get_bid!(bid.uuid) == bid
    end

    test "create_bid/1 with valid data creates a bid" do
      assert bid = TestHelpers.bid_fixture()
      assert bid.bid_price == 42
    end

    test "create_bid/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserItem.create_bid(@invalid_attrs)
    end

    test "create_bid/1 with invalid price returns error changeset" do
      bid = TestHelpers.bid_fixture()
      initial_bid = Repo.get_by!(Bid, uuid: bid.uuid)
      |> Repo.preload(:user)
      |> Repo.preload(:item)

      user = initial_bid.user
      item = initial_bid.item

      UserItem.create_bid(%{bid_price: 43, uuid: Ecto.UUID.generate(), user_id: user.id, item_id: item.id})
      UserItem.create_bid(%{bid_price: 44, uuid: Ecto.UUID.generate(), user_id: user.id, item_id: item.id})
      UserItem.create_bid(%{bid_price: 45, uuid: Ecto.UUID.generate(), user_id: user.id, item_id: item.id})

      invalid_create_attrs = %{
        bid_price: 45,
        item_id: item.id,
        user_id: user.id,
        uuid: Ecto.UUID.generate()
      }

      assert {:error, %Ecto.Changeset{}} = UserItem.create_bid(invalid_create_attrs)
    end

    test "create_bid/1 with invalid date returns error changeset" do
      user = TestHelpers.user_fixture()
      item = TestHelpers.item_fixture(%{user_id: user.id, end_date: "2020-07-31T06:59:59.000Z"})

      invalid_create_attrs = %{
        bid_price: 42,
        item_id: item.id,
        user_id: user.id,
        uuid: Ecto.UUID.generate(),
        timestamp: "2020-08-31T06:59:59.000Z"
      }

      assert {:error, %Ecto.Changeset{}} = UserItem.create_bid(invalid_create_attrs)
    end

    test "change_bid/1 returns a bid changeset" do
      bid = TestHelpers.bid_fixture()
      assert %Ecto.Changeset{} = UserItem.change_bid(bid)
    end

    test "list_bids_by_user/1 returns user bids by item" do
      _bids = many_bids_fixture()
      user_bids = UserItem.list_bids_by_user(@user_uuid);
      assert length(user_bids) == 2

      item1 = user_bids
      |> Enum.at(0)
      assert length(item1 |> Map.get(:bids)) == 2
      assert item1 |> Map.has_key?(:item) == true

      item2 = user_bids
      |> Enum.at(1)
      assert length(item2 |> Map.get(:bids)) == 2
      assert item2 |> Map.has_key?(:item) == true
    end
  end
end
