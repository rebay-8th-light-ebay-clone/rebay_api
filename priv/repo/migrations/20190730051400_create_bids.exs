defmodule RebayApi.Repo.Migrations.CreateBids do
  use Ecto.Migration

  def change do
    create table(:bids) do
      add :bid_price, :integer
      add :uuid, :uuid
      add :timestamp, :utc_datetime
      add :item_id, references(:items, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:bids, [:item_id])
    create index(:bids, [:user_id])
  end

  def down do
    drop_if_exists table("bids")
  end
end
