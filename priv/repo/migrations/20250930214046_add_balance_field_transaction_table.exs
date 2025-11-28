defmodule CurrencyExchange.Repo.Migrations.AddBalanceFieldTransactionTable do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :balance, :integer, default: 0, null: false
    end
  end
end
