defmodule RebayApi.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :title, :string
      add :description, :string
      add :image, :string
      add :price, :float
      add :category, :string
      add :end_date, :utc_datetime

      timestamps()
    end

  end
end