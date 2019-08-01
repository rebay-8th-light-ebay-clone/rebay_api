defmodule RebayApi.ListingsTest do
  use RebayApi.DataCase

  alias RebayApi.Listings

  describe "items" do
    alias RebayApi.Listings.Item
    alias RebayApi.TestHelpers

    @valid_attrs %{category: "some category", description: "some description", end_date: "2030-04-17T14:00:00Z", image: "http://www.some-image.foo", price: 1205, title: "some title", uuid: Ecto.UUID.generate()}
    @update_attrs %{category: "some updated category", description: "some updated description", end_date: "2030-05-18T15:01:01Z", image: "http://www.some-updated-image.foo", price: 4567, title: "some updated title"}
    @invalid_attrs %{category: nil, description: nil, end_date: nil, image: nil, price: nil, title: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Listings.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Listings.list_items() == [item]
    end

    test "get_items_by_user/1 returns the item for a given user uuid" do
      user = TestHelpers.user_fixture()
      user2 = TestHelpers.user_fixture()
      item1 = item_fixture(%{ user_id: user.id })
      item2 = item_fixture(%{ user_id: user.id })
      item3 = item_fixture(%{ user_id: user2.id })
      assert Listings.get_items_by_user(user.uuid) == [item1, item2]
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Listings.create_item(@valid_attrs)
      assert item.category == @valid_attrs.category
      assert item.description == @valid_attrs.description
      assert item.image == @valid_attrs.image
      assert item.price == @valid_attrs.price
      assert item.title == @valid_attrs.title
      assert item.end_date == DateTime.from_naive!(~N[2030-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_item/1 with invalid date returns error changeset" do
      invalid_attrs = Map.put(@valid_attrs, :end_date, "2005-04-17T14:00:00Z")
      assert {:error, %Ecto.Changeset{}} = Listings.create_item(invalid_attrs)
    end

    test "create_item/1 with invalid price returns error changeset" do
      invalid_attrs = Map.put(@valid_attrs, :price, 99)
      assert {:error, %Ecto.Changeset{}} = Listings.create_item(invalid_attrs)
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Listings.create_item()
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, %Item{} = item} = Listings.update_item(item, @update_attrs)
      assert item.category == @update_attrs.category
      assert item.description == @update_attrs.description
      assert item.image == @update_attrs.image
      assert item.price == @update_attrs.price
      assert item.title == @update_attrs.title
      assert item.end_date == DateTime.from_naive!(~N[2030-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Listings.update_item(item, @invalid_attrs)
      assert item == Listings.get_item!(item.uuid)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Listings.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Listings.get_item!(item.uuid) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Listings.change_item(item)
    end
  end
end
