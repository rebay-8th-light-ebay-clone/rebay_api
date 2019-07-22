defmodule RebayApi.TestHelpers do
  alias RebayApi.Repo
  alias RebayApi.Accounts.User

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
end