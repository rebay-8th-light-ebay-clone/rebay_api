defmodule RebayApi.Repo.Migrations.UpdateItemsTable do
  use Ecto.Migration

  def change do
    alter table("items") do
      add :uuid, :uuid
    end
  end
end
