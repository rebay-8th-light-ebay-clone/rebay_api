defmodule RebayApiWeb.BidControllerTest do
  use RebayApiWeb.ConnCase

  alias RebayApi.UserItem
  alias RebayApi.UserItem.Bid

  @create_attrs %{
    bid_price: 42
  }
  @update_attrs %{
    bid_price: 43
  }
  @invalid_attrs %{bid_price: nil}

  def fixture(:bid) do
    {:ok, bid} = UserItem.create_bid(@create_attrs)
    bid
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all bids", %{conn: conn} do
      conn = get(conn, Routes.bid_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create bid" do
    test "renders bid when data is valid", %{conn: conn} do
      conn = post(conn, Routes.bid_path(conn, :create), bid: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.bid_path(conn, :show, id))

      assert %{
               "id" => id,
               "bid_price" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.bid_path(conn, :create), bid: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update bid" do
    setup [:create_bid]

    test "renders bid when data is valid", %{conn: conn, bid: %Bid{id: id} = bid} do
      conn = put(conn, Routes.bid_path(conn, :update, bid), bid: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.bid_path(conn, :show, id))

      assert %{
               "id" => id,
               "bid_price" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, bid: bid} do
      conn = put(conn, Routes.bid_path(conn, :update, bid), bid: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete bid" do
    setup [:create_bid]

    test "deletes chosen bid", %{conn: conn, bid: bid} do
      conn = delete(conn, Routes.bid_path(conn, :delete, bid))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.bid_path(conn, :show, bid))
      end
    end
  end

  defp create_bid(_) do
    bid = fixture(:bid)
    {:ok, bid: bid}
  end
end
