defmodule CurrencyExchange.Repo.Migrations.RemoveParentIdFromTransactions do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      remove :parent_id, :id
    end
  end
end
