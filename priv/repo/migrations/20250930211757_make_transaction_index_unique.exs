defmodule CurrencyExchange.Repo.Migrations.MakeTransactionIndexUnique do
  use Ecto.Migration

  def change do
    drop_if_exists index(
      :transactions,
      [],
      name: :transactions_user_id_currency_inserted_at_DESC_index
    )

    create unique_index(
      :transactions,
      [:user_id, :currency, "inserted_at DESC"],
      name: :transactions_user_id_currency_inserted_at_DESC_unique_index
    )

  end
end
