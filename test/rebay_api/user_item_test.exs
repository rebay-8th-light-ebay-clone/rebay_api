defmodule RebayApi.UserItemTest do
  use RebayApi.DataCase

  alias RebayApi.UserItem
  alias RebayApi.TestHelpers
  alias RebayApi.UserItem.Bid
  alias RebayApi.Accounts.Item

  describe "bids" do
    @uuid Ecto.UUID.generate()
    @user_uuid Ecto.UUID.generate()
    @valid_attrs %{bid_price: 42, uuid: @uuid}
    @update_attrs %{bid_price: 43}
    @invalid_attrs %{bid_price: nil}

    def bid_fixture(attrs \\ %{}) do
      {:ok, bid} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserItem.create_bid()

      bid
    end

    def many_bids_fixture() do
      user = TestHelpers.user_fixture(%{uuid: @user_uuid})
      item1 = TestHelpers.item_fixture(%{
        title: "item 1 title",
        user_id: user.id,
        end_date: "2020-08-31T06:59:59Z"
      })
      item2 = TestHelpers.item_fixture(%{
        title: "item 2 title",
        user_id: user.id,
        end_date: "2020-08-31T06:59:59Z"
      })
      bid1 = bid_fixture(%{
        bid_price: 1,
        user_id: user.id,
        item_id: item1.id
      })
      bid2 = bid_fixture(%{
        bid_price: 2,
        user_id: user.id,
        item_id: item1.id
      })
      bid3 = bid_fixture(%{
        bid_price: 3,
        user_id: user.id,
        item_id: item2.id
      })
      bid4 = bid_fixture(%{
        bid_price: 4,
        user_id: user.id,
        item_id: item2.id
      })
      [bid1, bid2, bid3, bid4]
    end

    test "list_bids/0 returns all bids" do
      bid = bid_fixture()
      assert UserItem.list_bids() == [bid]
    end

    test "get_bid!/1 returns the bid with given id" do
      bid = bid_fixture()
      assert UserItem.get_bid!(bid.uuid) == bid
    end

    test "create_bid/1 with valid data creates a bid" do
      assert {:ok, %Bid{} = bid} = UserItem.create_bid(@valid_attrs)
      assert bid.bid_price == 42
    end

    test "create_bid/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserItem.create_bid(@invalid_attrs)
    end

    test "update_bid/2 with valid data updates the bid" do
      bid = bid_fixture()
      assert {:ok, %Bid{} = bid} = UserItem.update_bid(bid, @update_attrs)
      assert bid.bid_price == 43
    end

    test "update_bid/2 with invalid data returns error changeset" do
      bid = bid_fixture()
      assert {:error, %Ecto.Changeset{}} = UserItem.update_bid(bid, @invalid_attrs)
      assert bid == UserItem.get_bid!(bid.uuid)
    end

    test "delete_bid/1 deletes the bid" do
      bid = bid_fixture()
      assert {:ok, %Bid{}} = UserItem.delete_bid(bid)
      assert_raise Ecto.NoResultsError, fn -> UserItem.get_bid!(bid.uuid) end
    end

    test "change_bid/1 returns a bid changeset" do
      bid = bid_fixture()
      assert %Ecto.Changeset{} = UserItem.change_bid(bid)
    end

    test "list_bids_by_user/1 returns user bids by item" do
      bids = many_bids_fixture()
      user_bids = UserItem.list_bids_by_user(@user_uuid);
      assert length(user_bids) == 2

      item1 = user_bids
      |> Enum.at(0)
      assert length(item1 |> Map.get(:bids)) == 2
      assert item1 |> Map.has_key?(:item) == true

      item2 = user_bids
      |> Enum.at(1)
      assert length(item1 |> Map.get(:bids)) == 2
      assert item1 |> Map.has_key?(:item) == true
    end
  end
end
