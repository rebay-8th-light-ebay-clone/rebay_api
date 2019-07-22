defmodule RebayApi.ListingsTest do
  use RebayApi.DataCase

  alias RebayApi.Listings

  describe "items" do
    alias RebayApi.Listings.Item

    @valid_attrs %{category: "some category", description: "some description", end_date: "2010-04-17T14:00:00Z", image: "some image", price: 1205, title: "some title"}
    @update_attrs %{category: "some updated category", description: "some updated description", end_date: "2011-05-18T15:01:01Z", image: "some updated image", price: 4567, title: "some updated title"}
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

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Listings.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Listings.create_item(@valid_attrs)
      assert item.category == "some category"
      assert item.description == "some description"
      assert item.end_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert item.image == "some image"
      assert item.price == 1205
      assert item.title == "some title"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Listings.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, %Item{} = item} = Listings.update_item(item, @update_attrs)
      assert item.category == "some updated category"
      assert item.description == "some updated description"
      assert item.end_date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert item.image == "some updated image"
      assert item.price == 4567
      assert item.title == "some updated title"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Listings.update_item(item, @invalid_attrs)
      assert item == Listings.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Listings.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Listings.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Listings.change_item(item)
    end
  end
end
