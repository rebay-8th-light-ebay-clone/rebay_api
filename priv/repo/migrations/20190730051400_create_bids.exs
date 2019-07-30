defmodule RebayApi.Repo.Migrations.CreateBids do
  use Ecto.Migration

  def change do
    create table(:bids) do
      add :bid_price, :integer
      add :user_uuid, references(:users, on_delete: :nothing)
      add :item_uuid, references(:items, on_delete: :nothing)

      timestamps()
    end

    create index(:bids, [:user_uuid])
    create index(:bids, [:item_uuid])
  end

  def down do
    drop_if_exists table("bids")
  end
end
