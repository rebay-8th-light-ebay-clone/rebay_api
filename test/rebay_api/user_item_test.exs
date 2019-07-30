defmodule RebayApi.UserItemTest do
  use RebayApi.DataCase

  alias RebayApi.UserItem

  describe "bids" do
    alias RebayApi.UserItem.Bid

    @valid_attrs %{bid_price: 42}
    @update_attrs %{bid_price: 43}
    @invalid_attrs %{bid_price: nil}

    def bid_fixture(attrs \\ %{}) do
      {:ok, bid} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserItem.create_bid()

      bid
    end

    test "list_bids/0 returns all bids" do
      bid = bid_fixture()
      assert UserItem.list_bids() == [bid]
    end

    test "get_bid!/1 returns the bid with given id" do
      bid = bid_fixture()
      assert UserItem.get_bid!(bid.id) == bid
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
      assert bid == UserItem.get_bid!(bid.id)
    end

    test "delete_bid/1 deletes the bid" do
      bid = bid_fixture()
      assert {:ok, %Bid{}} = UserItem.delete_bid(bid)
      assert_raise Ecto.NoResultsError, fn -> UserItem.get_bid!(bid.id) end
    end

    test "change_bid/1 returns a bid changeset" do
      bid = bid_fixture()
      assert %Ecto.Changeset{} = UserItem.change_bid(bid)
    end
  end
end
