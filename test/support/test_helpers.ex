defmodule RebayApi.TestHelpers do
  use Plug.Test

  alias RebayApi.Repo
  alias RebayApi.Accounts.User
  alias RebayApi.Listings.Item
  alias RebayApi.UserItem.Bid

  def valid_session(conn, user) do
    conn
    |> assign(:user, user)
    |> init_test_session(id: "test_id_token")
    |> put_session(:user_uuid, user.uuid)
    |> put_resp_cookie("session_id", "test_id_token", [http_only: true, secure: false])
  end

  def user_fixture(attrs \\ %{}) do
    params =
      attrs
      |> Enum.into(%{
        avatar: "some-image-url.foo",
        email: "travis@foo.fake",
        first_name: "delete this user",
        provider: "google",
        uuid: Ecto.UUID.generate(),
      })

    {:ok, user} =
      User.changeset(%User{}, params)
      |> Repo.insert()

    user
  end

  def item_fixture(attrs \\ %{}) do
    params =
      attrs
      |> Enum.into(%{
        category: "some category",
        description: "some description",
        end_date: "2020-07-31T06:59:59.000Z",
        image: "some image",
        price: 1205,
        title: "some title",
        uuid: Ecto.UUID.generate(),
      })

    {:ok, item} =
      Item.changeset(%Item{}, params)
      |> Repo.insert()

    item
  end

  def bid_fixture(attrs \\ %{}) do
    user = user_fixture()
    item = item_fixture(%{user_id: user.id})
    bidding_user = user_fixture()

    params =
      attrs
      |> Enum.into(%{
        bid_price: 42,
        uuid: Ecto.UUID.generate(),
        user_id: bidding_user.id,
        item_id: item.id
      })

    {:ok, bid} =
      Bid.changeset(%Bid{}, params)
      |> Repo.insert()

    bid
  end
end
