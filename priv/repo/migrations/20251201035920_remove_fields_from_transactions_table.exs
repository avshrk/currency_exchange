defmodule CurrencyExchange.Repo.Migrations.RemoveFieldsFromTransactionsTable do
  use Ecto.Migration

  def change do
    alter table(:transactions)  do
      remove :rate, :string
      remove :currency_pair, :string
    end
  end
end
