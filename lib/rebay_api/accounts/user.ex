defmodule RebayApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :avatar, :string
    field :email, :string
    field :first_name, :string
    field :provider, :string
    field :token, :string
    field :uuid, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :provider, :token, :avatar, :first_name, :uuid])
    |> validate_required([:email, :provider, :token, :avatar, :first_name, :uuid])
  end
end
