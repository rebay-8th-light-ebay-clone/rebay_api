defmodule RebayApiWeb.ItemControllerTest do
  use RebayApiWeb.ConnCase

  alias RebayApi.Listings
  alias RebayApi.Listings.Item
  alias RebayApi.TestHelpers

  @uuid Ecto.UUID.generate()
  @create_attrs %{
    category: "some category",
    description: "some description",
    end_date: "2010-04-17T14:00:00Z",
    image: "some image",
    price: 1205,
    title: "some title",
    uuid: @uuid
  }
  @update_attrs %{
    category: "some updated category",
    description: "some updated description",
    end_date: "2011-05-18T15:01:01Z",
    image: "some updated image",
    price: 4567,
    title: "some updated title"
  }
  @invalid_attrs %{category: nil, description: nil, end_date: nil, image: nil, price: nil, title: nil}

  def fixture(:item) do
    {:ok, item} = Listings.create_item(@create_attrs)
    item
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get(conn, Routes.item_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show" do
    setup [:create_item]
    test "lists one item", %{conn: conn, item: item} do
      user = TestHelpers.user_fixture()
      conn = get(conn, Routes.user_item_path(conn, :show, user.uuid, item.uuid))
      assert json_response(conn, 200)["data"] == %{
        "category" => "some category",
        "description" => "some description",
        "end_date" => "2010-04-17T14:00:00Z",
        "image" => "some image",
        "price" => 1205,
        "title" => "some title",
        "uuid" => @uuid
      }
    end
  end

  describe "create item" do
    test "renders item when data is valid", %{conn: conn} do
      user = TestHelpers.user_fixture()
      conn = conn
      |> assign(:user, user)
      |> post(Routes.user_item_path(conn, :create, user.uuid), item: @create_attrs)

      assert %{"uuid" => uuid} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_item_path(conn, :show, user.uuid, uuid))

      assert %{
               "category" => "some category",
               "description" => "some description",
               "end_date" => "2010-04-17T14:00:00Z",
               "image" => "some image",
               "price" => 1205,
               "title" => "some title",
               "uuid" => uuid,
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = TestHelpers.user_fixture()
      conn = post(conn, Routes.user_item_path(conn, :create, user.uuid), item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update item" do
    setup [:create_item]

    test "renders item when data is valid", %{conn: conn, item: %Item{uuid: uuid} = item} do
      user = TestHelpers.user_fixture()
      conn = put(conn, Routes.user_item_path(conn, :update, user.uuid, item.uuid), item: @update_attrs)
      assert %{"uuid" => ^uuid} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_item_path(conn, :show, user.uuid, item.uuid))

      assert %{
               "category" => "some updated category",
               "description" => "some updated description",
               "end_date" => "2011-05-18T15:01:01Z",
               "image" => "some updated image",
               "price" => 4567,
               "title" => "some updated title",
               "uuid" => uuid,
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, item: item} do
      user = TestHelpers.user_fixture()
      conn = put(conn, Routes.user_item_path(conn, :update, user.uuid, item.uuid), item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete item" do
    setup [:create_item]

    test "deletes chosen item", %{conn: conn, item: item} do
      user = TestHelpers.user_fixture()
      conn = delete(conn, Routes.user_item_path(conn, :delete, user.uuid, item.uuid))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_item_path(conn, :show, user.uuid, item.uuid))
      end
    end
  end

  defp create_item(_) do
    item = fixture(:item)
    {:ok, item: item}
  end
end
