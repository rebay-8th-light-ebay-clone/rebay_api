defmodule RebayApiWeb.ItemControllerTest do
  use RebayApiWeb.ConnCase
  use Plug.Test

  alias RebayApi.Listings
  alias RebayApi.Listings.Item
  alias RebayApi.TestHelpers
  alias RebayApi.Repo

  @uuid Ecto.UUID.generate()
  @create_attrs %{
    category: "some category",
    description: "some description",
    end_date: "2019-07-31T06:59:59.000Z",
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
    user = TestHelpers.user_fixture()
    {:ok, item} = Listings.create_item(Map.put(@create_attrs, :user_id, user.id))
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
      conn = get(conn, Routes.user_item_path(conn, :show, item.user.uuid, item.uuid))
      assert json_response(conn, 200)["data"] == %{
        "category" => "some category",
        "description" => "some description",
        "end_date" => "2019-07-31T06:59:59Z",
        "image" => "some image",
        "price" => 1205,
        "title" => "some title",
        "uuid" => @uuid,
        "user_uuid" => item.user.uuid
      }
    end
  end

  describe "create item" do
    setup [:create_user]
    test "renders item when data is valid", %{conn: conn, user: user} do
      conn = valid_session(conn, user)
      |> post(Routes.user_item_path(conn, :create, user.uuid), @create_attrs)

      assert %{"uuid" => uuid} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_item_path(conn, :show, user.uuid, uuid))

      assert %{
               "category" => "some category",
               "description" => "some description",
               "end_date" => "2019-07-31T06:59:59Z",
               "image" => "some image",
               "price" => 1205,
               "title" => "some title",
               "uuid" => uuid,
             } = json_response(conn, 200)["data"]
    end

    test "associates the item with the correct user", %{conn: conn, user: user} do
      conn = valid_session(conn, user)
      |> post(Routes.user_item_path(conn, :create, user.uuid), @create_attrs)

      assert %{"uuid" => uuid} = json_response(conn, 201)["data"]

      item = Item
      |> Repo.get_by!(uuid: uuid)
      |> Repo.preload(:user)

      assert item.user == user
    end


    test "renders error when user is logged in but request is not authenticated", %{conn: conn, user: user} do
      conn = init_test_session(conn, id: "test_id_token")
      |> post(Routes.user_item_path(conn, :create, user.uuid, item: @create_attrs))

      assert json_response(conn, 401)["errors"] != %{}
    end

    test "renders error when user is not logged in", %{conn: conn, user: user} do
      conn = post(conn, Routes.user_item_path(conn, :create, user.uuid, item: @create_attrs))

      assert json_response(conn, 401)["errors"] != %{}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = valid_session(conn, user)
      |> post(Routes.user_item_path(conn, :create, user.uuid), @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update item" do
    setup [:create_item, :create_user]

    test "renders item when data is valid", %{conn: conn, item: %Item{uuid: uuid} = item, user: user} do
      conn = valid_session(conn, user)
      |> put(Routes.user_item_path(conn, :update, user.uuid, item.uuid), [item: @update_attrs])

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

    test "renders error when request is not authenticated", %{conn: conn, item: item, user: user} do
      conn = init_test_session(conn, id: "test_id_token")
      |> put(Routes.user_item_path(conn, :update, user.uuid, item.uuid), item: @update_attrs)

      assert json_response(conn, 401)["errors"] != %{}
    end

    test "renders error when user is not authorized", %{conn: conn, item: item, user: user} do
      conn = valid_session(conn, user)
      |> put(Routes.user_item_path(conn, :update, item.user.uuid, item.uuid), [item: @update_attrs, cookie: %{session_id: "test_id_token"}])

      assert json_response(conn, 401)["errors"] != %{}
    end

    test "renders errors when data is invalid", %{conn: conn, item: item, user: user} do
      conn = valid_session(conn, user)
      |> put(Routes.user_item_path(conn, :update, user.uuid, item.uuid), item: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete item" do
    setup [:create_item, :create_user]

    test "deletes chosen item", %{conn: conn, item: item, user: user} do
      conn = valid_session(conn, user)
      |> delete(Routes.user_item_path(conn, :delete, user.uuid, item.uuid))

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_item_path(conn, :show, user.uuid, item.uuid))
      end
    end

    test "renders error when request is not authenticated", %{conn: conn, item: item, user: user} do
      conn = init_test_session(conn, id: "test_id_token")
      |> delete(Routes.user_item_path(conn, :delete, user.uuid, item.uuid))
      
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  defp create_item(_) do
    item = fixture(:item)
    item = Item
    |> Repo.get_by!(uuid: item.uuid)
    |> Repo.preload(:user)

    {:ok, item: item}
  end

  defp create_user(_) do
    user = TestHelpers.user_fixture()
    {:ok, user: user}
  end

  defp valid_session(conn, user) do
    conn
    |> assign(:user, user)
    |> init_test_session(id: "test_id_token")
    |> put_session(:user_uuid, user.uuid)
    |> put_resp_cookie("session_id", "test_id_token", [http_only: true, secure: false])
  end
end
