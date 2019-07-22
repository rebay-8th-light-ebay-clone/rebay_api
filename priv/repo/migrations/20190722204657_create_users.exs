defmodule RebayApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :provider, :string
      add :avatar, :string
      add :first_name, :string
      add :uuid, :uuid

      timestamps()
    end
  end

  def down do
    drop_if_exists table(:users)
  end
end
