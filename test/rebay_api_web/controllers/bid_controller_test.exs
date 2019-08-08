defmodule RebayApiWeb.BidControllerTest do
  use RebayApiWeb.ConnCase
  use Plug.Test

  alias RebayApi.UserItem
  alias RebayApi.UserItem.Bid
  alias RebayApi.TestHelpers
  alias RebayApi.Listings
  alias RebayApi.Accounts
  alias RebayApi.Repo

  @uuid Ecto.UUID.generate()
  @user_uuid Ecto.UUID.generate()
  @item_uuid Ecto.UUID.generate()
  @invalid_attrs %{bid_price: nil, user_id: nil, item_id: nil, uuid: nil}

  def create_bid_attrs() do
    user = TestHelpers.user_fixture(%{ uuid: @user_uuid })
    item = TestHelpers.item_fixture(%{ user_id: user.id, uuid: @item_uuid,  end_date: "2020-08-31T06:59:59Z", })
    %{
      bid_price: 42,
      uuid: @uuid,
      item_id: item.id,
      user_id: user.id,
    }
  end

  def fixture(:bid) do
    {:ok, bid} = UserItem.create_bid(create_bid_attrs())
    bid
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_bid]
    test "lists all bids for an item", %{conn: conn, bid: bid} do
      item_id = bid.item_id
      item_uuid = Listings.get_item_by_id!(item_id).uuid
      conn = get(conn, Routes.item_bid_path(conn, :index_by_item, item_uuid))
      assert [%{
        "bid_price" => 42,
        "uuid" => @uuid,
        "item_uuid" => item_uuid,
      }] = json_response(conn, 200)["data"]
    end

    test "list all bids for a user", %{conn: conn, bid: bid} do
      conn = TestHelpers.valid_session(conn, bid.user)
      conn = get(conn, Routes.user_bid_path(conn, :index_by_user, bid.user.uuid))
      assert [
        %{
          "bids" => [
            %{
              "bid_price" => 42,
              "item_uuid" => @item_uuid,
              "user_uuid" => @user_uuid,
              "uuid" => @uuid
            }
          ],
          "item" => %{
            "category" => "some category",
            "description" => "some description",
            "end_date" => "2020-08-31T06:59:59Z",
            "image" => "some image",
            "price" => 1205,
            "title" => "some title",
            "user_uuid" => @user_uuid,
            "uuid" => @item_uuid
          }
        }
      ] = json_response(conn, 200)["data"]
    end

    test "returns error when user is logged in but request is not authenticated", %{conn: conn, bid: bid} do
      conn = TestHelpers.invalid_session(conn, "test_id_token")
      |> get(Routes.user_bid_path(conn, :index_by_user, bid.user.uuid))

      assert json_response(conn, 401)["errors"] != %{}
    end

    test "renders error when user is not logged in", %{conn: conn, bid: bid} do
      conn = conn |> get(Routes.user_bid_path(conn, :index_by_user, bid.user.uuid))

      assert json_response(conn, 401)["errors"] != %{}
    end

    test "returns error when a logged in user tries to retrieve another users bids", %{conn: conn, bid: bid} do
      conn = TestHelpers.valid_session(conn, bid.user)
      |> get(Routes.user_bid_path(conn, :index_by_user, Ecto.UUID.generate()))

      assert json_response(conn, 403)["errors"] != %{}
    end
  end

  describe "create bid" do
    test "renders bid when data is valid", %{conn: conn} do
      item_owner = TestHelpers.user_fixture()
      item = TestHelpers.item_fixture(%{user_id: item_owner.id, uuid: Ecto.UUID.generate()})
      item_uuid = item.uuid
      user = TestHelpers.user_fixture()
      _user_uuid = user.uuid

      conn = conn
      |> TestHelpers.valid_session(user)
      |> post(Routes.item_bid_path(conn, :create, item_uuid), %{bid_price: 100})
      assert %{"uuid" => uuid} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.item_bid_path(conn, :show, item_uuid, uuid))

      assert %{
              "bid_price" => 100,
              "uuid" => uuid,
              "user_uuid" => user_uuid,
              "item_uuid" => item_uuid
             } = json_response(conn, 200)["data"]
    end

    test "renders bid with max bid price when data is valid", %{conn: conn} do
      item_owner = TestHelpers.user_fixture()
      item = TestHelpers.item_fixture(%{user_id: item_owner.id, uuid: Ecto.UUID.generate()})
      item_uuid = item.uuid
      user = TestHelpers.user_fixture()
      _user_uuid = user.uuid

      conn = conn
      |> TestHelpers.valid_session(user)
      |> post(Routes.item_bid_path(conn, :create, item_uuid), %{bid_price: 100, max_bid_price: 200 })
      assert %{"uuid" => uuid} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.item_bid_path(conn, :show, item_uuid, uuid))

      assert %{
              "bid_price" => 100,
              "uuid" => uuid,
              "user_uuid" => user_uuid,
              "item_uuid" => item_uuid,
              "max_bid_price" => 200
             } = json_response(conn, 200)["data"]
    end

    test "associates bid with the correct user and item", %{conn: conn} do
      user = TestHelpers.user_fixture()
      item_owner = TestHelpers.user_fixture()
      item = TestHelpers.item_fixture(%{user_id: item_owner.id, uuid: Ecto.UUID.generate()})
      user_uuid = user.uuid
      item_uuid = item.uuid

      conn
      |> TestHelpers.valid_session(user)
      |> post(Routes.item_bid_path(conn, :create, item.uuid), %{bid_price: 100})

      expected_user = Accounts.get_user!(user_uuid)
      |> Repo.preload(:bids)

      expected_item = Listings.get_item!(item_uuid)
      |> Repo.preload(:bids)

      assert length(expected_user.bids) == 1
      assert length(expected_item.bids) == 1
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = TestHelpers.user_fixture()
      item_owner = TestHelpers.user_fixture()
      item = TestHelpers.item_fixture(%{user_id: item_owner.id})
      conn = conn
      |> TestHelpers.valid_session(user)
      |> post(Routes.item_bid_path(conn, :create, item.uuid), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders error when max bid price is lower than or equal to price", %{conn: conn} do
      user = TestHelpers.user_fixture()
      item_owner = TestHelpers.user_fixture()
      item = TestHelpers.item_fixture(%{user_id: item_owner.id})
      conn = conn
      |> TestHelpers.valid_session(user)
      |> post(Routes.item_bid_path(conn, :create, item.uuid), %{bid_price: 100, max_bid_price: 100 })
      assert json_response(conn, 422)["errors"] == %{"bid_price" => ["max bid price must be greater than minimum price"]}
    end

    test "returns error when user is logged in but request is not authenticated", %{conn: conn} do
      item = TestHelpers.item_fixture
      conn = TestHelpers.invalid_session(conn, "test_id_token")
      |> post(Routes.item_bid_path(conn, :create, item.uuid), bid: create_bid_attrs())

      assert json_response(conn, 401)["errors"] != %{}
    end

    test "returns error when user tries to bid on their own item", %{conn: conn} do
      user = TestHelpers.user_fixture()
      item = TestHelpers.item_fixture(%{ user_id: user.id })
      conn = conn
      |> TestHelpers.valid_session(user)
      |> post(Routes.item_bid_path(conn, :create, item.uuid), %{bid_price: 100})

      assert json_response(conn, 403)["errors"] != %{}
    end

    test "renders error when user is not logged in", %{conn: conn} do
      item = TestHelpers.item_fixture
      conn = conn |> post(Routes.item_bid_path(conn, :create, item.uuid), bid: create_bid_attrs())

      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "auto bids" do
    test "triggers auto bids after a new bid creation", %{conn: conn} do
      item_owner = TestHelpers.user_fixture()
      item = TestHelpers.item_fixture(%{user_id: item_owner.id, price: 100})
      user1 = TestHelpers.user_fixture()
      user2 = TestHelpers.user_fixture()
      user3 = TestHelpers.user_fixture()
      bid_uuid = Ecto.UUID.generate()
      item_owner_uuid = item_owner.uuid
      item_uuid = item.uuid
      TestHelpers.bid_fixture(%{ max_bid_price: 700, bid_price: 200, item_id: item.id, user_id: user1.id })
      TestHelpers.bid_fixture(%{ max_bid_price: 900, bid_price: 300, item_id: item.id, user_id: user2.id })

      conn = conn
      |> TestHelpers.valid_session(user3)
      |> post(Routes.item_bid_path(conn, :create, item.uuid), %{ bid_price: 400, uuid: bid_uuid })
      assert %{"uuid" => uuid} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_item_path(conn, :show, item_owner_uuid, item_uuid))
      assert %{
        "category" => "some category",
        "current_highest_bid" => 800,
        "description" => "some description",
        "end_date" => "2020-07-31T06:59:59Z",
        "image" => "some image",
        "price" => 100,
        "title" => "some title",
        "user_uuid" => item_owner_uuid,
        "uuid" => item_uuid
      } == json_response(conn, 200)["data"]
    end

    test "does not trigger bidding users auto bids after a new bid creation", %{conn: conn} do
      item_owner = TestHelpers.user_fixture()
      item = TestHelpers.item_fixture(%{user_id: item_owner.id, price: 100})
      user1 = TestHelpers.user_fixture()
      user2 = TestHelpers.user_fixture()
      bid_uuid = Ecto.UUID.generate()
      item_owner_uuid = item_owner.uuid
      item_uuid = item.uuid
      TestHelpers.bid_fixture(%{ max_bid_price: 600, bid_price: 200, item_id: item.id, user_id: user1.id })
      TestHelpers.bid_fixture(%{ max_bid_price: 700, bid_price: 300, item_id: item.id, user_id: user2.id })

      conn = conn
      |> TestHelpers.valid_session(user1)
      |> post(Routes.item_bid_path(conn, :create, item.uuid), %{ bid_price: 400, uuid: bid_uuid })
      assert %{"uuid" => uuid} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_item_path(conn, :show, item_owner_uuid, item_uuid))
      assert %{
        "category" => "some category",
        "current_highest_bid" => 700,
        "description" => "some description",
        "end_date" => "2020-07-31T06:59:59Z",
        "image" => "some image",
        "price" => 100,
        "title" => "some title",
        "user_uuid" => item_owner_uuid,
        "uuid" => item_uuid
      } == json_response(conn, 200)["data"]
    end
  end

  defp create_bid(_) do
    bid = fixture(:bid)
    bid = Bid
    |> Repo.get_by!(uuid: bid.uuid)
    |> Repo.preload(:user)
    |> Repo.preload(:item)

    {:ok, bid: bid}
  end
end
