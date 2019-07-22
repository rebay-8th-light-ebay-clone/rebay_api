defmodule RebayApi.AccountsTest do
  use RebayApi.DataCase

  alias RebayApi.Accounts

  describe "users" do
    alias RebayApi.Accounts.User

<<<<<<< HEAD
    @valid_attrs %{avatar: "some avatar", email: "some email", first_name: "some first_name", provider: "some provider", uuid: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{avatar: "some updated avatar", email: "some updated email", first_name: "some updated first_name", provider: "some updated provider", uuid: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{avatar: nil, email: nil, first_name: nil, provider: nil, uuid: nil}
=======
    @valid_attrs %{avatar: "some avatar", email: "some email", first_name: "some first_name", provider: "some provider", token: "some token", uuid: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{avatar: "some updated avatar", email: "some updated email", first_name: "some updated first_name", provider: "some updated provider", token: "some updated token", uuid: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{avatar: nil, email: nil, first_name: nil, provider: nil, token: nil, uuid: nil}
>>>>>>> Setup Google OAuth with ueberauth

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
<<<<<<< HEAD
      assert Accounts.get_user!(user.uuid) == user
=======
      assert Accounts.get_user!(user.id) == user
>>>>>>> Setup Google OAuth with ueberauth
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.avatar == "some avatar"
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.provider == "some provider"
<<<<<<< HEAD
=======
      assert user.token == "some token"
>>>>>>> Setup Google OAuth with ueberauth
      assert user.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.avatar == "some updated avatar"
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.provider == "some updated provider"
<<<<<<< HEAD
=======
      assert user.token == "some updated token"
>>>>>>> Setup Google OAuth with ueberauth
      assert user.uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.uuid)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.uuid) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
