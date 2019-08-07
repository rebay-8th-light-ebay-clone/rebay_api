defmodule RebayApi.Repo.Migrations.UpdateBidsTable do
  use Ecto.Migration

  def change do
    alter table(:bids) do
      add :max_bid_price, :integer
    end
  end

  def down do
    drop_if_exists table("bids")
  end
end
