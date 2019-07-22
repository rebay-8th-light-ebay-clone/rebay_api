defmodule RebayApiWeb.UserControllerTest do
  use RebayApiWeb.ConnCase

  alias RebayApi.Accounts
  alias RebayApi.Accounts.User

  @create_attrs %{
    avatar: "some avatar",
    email: "some email",
    first_name: "some first_name",
    provider: "some provider",
    token: "some token",
    uuid: "7488a646-e31f-11e4-aace-600308960662"
  }
  @update_attrs %{
    avatar: "some updated avatar",
    email: "some updated email",
    first_name: "some updated first_name",
    provider: "some updated provider",
    token: "some updated token",
    uuid: "7488a646-e31f-11e4-aace-600308960668"
  }
  @invalid_attrs %{avatar: nil, email: nil, first_name: nil, provider: nil, token: nil, uuid: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "avatar" => "some avatar",
               "email" => "some email",
               "first_name" => "some first_name",
               "provider" => "some provider",
               "token" => "some token",
               "uuid" => "7488a646-e31f-11e4-aace-600308960662"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "avatar" => "some updated avatar",
               "email" => "some updated email",
               "first_name" => "some updated first_name",
               "provider" => "some updated provider",
               "token" => "some updated token",
               "uuid" => "7488a646-e31f-11e4-aace-600308960668"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
