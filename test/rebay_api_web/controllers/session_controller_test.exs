defmodule RebayApiWeb.SessionControllerTest do
  use RebayApiWeb.ConnCase
  alias RebayApi.Repo
  alias RebayApi.Accounts.User


  test "redirects user to Google for authentication", %{conn: conn} do
    conn = get conn, "/auth/google?scope=email%20profile"
    assert redirected_to(conn, 302)
  end

  test "handles cors pre-flight request", %{conn: conn} do
    conn = options conn, "/auth/google?scope=email%20profile"
    assert get_resp_header(conn, "access-control-allow-origin") == ["http://localhost:3000"]
  end

  test "handles  get request for auth route", %{conn: conn} do
    conn = get conn, "/auth/google?scope=email%20profile"
    assert get_resp_header(conn, "access-control-allow-origin") == ["http://localhost:3000"]
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
    conn
    |> assign(:ueberauth_auth, ueberauth_auth)
    |> get("/auth/google/callback")

    users = User |> Repo.all
    assert Enum.count(users) == 1
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
