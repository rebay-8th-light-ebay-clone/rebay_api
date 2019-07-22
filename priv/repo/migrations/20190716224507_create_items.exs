defmodule RebayApi.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :title, :string
      add :description, :string
      add :image, :string
      add :price, :integer
      add :category, :string
      add :end_date, :utc_datetime

      timestamps()
    end

    alter table(:items) do
      modify :title, :text
      modify :description, :text
      modify :image, :text
    end
  end

  def down do
    drop_if_exists table("items")
  end
end
