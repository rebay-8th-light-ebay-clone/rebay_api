defmodule RebayApiWeb.BidControllerTest do
  use RebayApiWeb.ConnCase
  use Plug.Test

  alias RebayApi.UserItem
  alias RebayApi.UserItem.Bid
  alias RebayApi.TestHelpers
  alias RebayApi.Listings
  alias RebayApi.Repo

  @uuid Ecto.UUID.generate()
  @user_uuid Ecto.UUID.generate()
  @item_uuid Ecto.UUID.generate()
  @invalid_attrs %{bid_price: nil}

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
      conn = get(conn, Routes.item_bid_path(conn, :index, item_uuid))
      assert [%{
        "bid_price" => 42,
        "uuid" => @uuid,
        "item_uuid" => item_uuid,
      }] = json_response(conn, 200)["data"]
    end

    test "list all bids for a user", %{conn: conn, bid: bid} do
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
  end

  describe "create bid" do
    test "renders bid when data is valid", %{conn: conn} do
      conn = post(conn, Routes.item_bid_path(conn, :create, @item_uuid), bid: create_bid_attrs())
      assert %{"uuid" => uuid} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.item_bid_path(conn, :show, 1, uuid))

      assert %{
               "uuid" => uuid,
               "bid_price" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.item_bid_path(conn, :create, @item_uuid), bid: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
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
