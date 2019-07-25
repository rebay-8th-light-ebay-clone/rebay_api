defmodule RebayApiWeb.SessionControllerTest do
  use RebayApiWeb.ConnCase
  alias RebayApi.Repo
  alias RebayApi.Accounts.User
  alias RebayApi.TestHelpers
  
  test "redirects user to Google for authentication", %{conn: conn} do
    conn = get conn, "/auth/google?scope=email%20profile"
    assert redirected_to(conn, 302)
  end
  
  test "creates user from Google information", %{conn: conn} do
    users = User |> Repo.all
    assert Enum.count(users) == 0

    ueberauth_auth = %{
      credentials: %{token: "fdsnoafhnoofh08h38h"},
      info: %{
        image: "some-image-url.foo",
        email: "travis@foo.fake", 
        first_name: "Travis", 
        provider: "google",
        token: "foo",
        },
      provider: :google
    }
    conn = conn
    |> assign(:ueberauth_auth, ueberauth_auth)
    |> get("/auth/google/callback")

    users = User |> Repo.all
    [ user | _ ] = users
    assert Enum.count(users) == 1
    assert get_resp_header(conn, "location") == ["http://localhost:3000/login/#{user.uuid}"]
    assert fetch_cookies(conn).cookies["session_id"] == "fdsnoafhnoofh08h38h"
  end

  test "signs out user", %{conn: conn} do
    user = TestHelpers.user_fixture()

    conn = conn
    |> assign(:user, user)
    |> get("/auth/signout")
    |> get("/api/items")

    assert conn.assigns[:user] == nil
  end

  test "signs out user", %{conn: conn} do
    user = TestHelpers.user_fixture()

    conn = conn
    |> assign(:user, user)
    |> get("/auth/signout")
    |> get("/api/items")

    assert conn.assigns[:user] == nil
  end

  test "handles errors", %{conn: conn} do
    ueberauth_auth = %{
      credentials: %{token: "fdsnoafhnoofh08h38h"},
      info: %{
        image: 0,
        email: "travis@foo.fake", 
        first_name: "Travis", 
        provider: "google",
        token: "foo",
        },
      provider: :google
    }
    conn
    |> assign(:ueberauth_auth, ueberauth_auth)
    |> get("/auth/google/callback")

    users = User |> Repo.all
    assert Enum.count(users) == 0
  end
end