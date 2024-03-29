defmodule RebayApi.Accounts do
  import Ecto.Query, warn: false
  alias RebayApi.Repo

  alias RebayApi.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(uuid), do: Repo.get_by!(User, uuid: uuid)

  def get_user_by_id!(id), do: Repo.get_by!(User, id: id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
