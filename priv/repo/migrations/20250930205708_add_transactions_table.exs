defmodule CurrencyExchange.Repo.Migrations.AddTransactionsTable do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :parent_id, references(:transactions, on_delete: :nothing)
      add :currency, :string, null: false
      add :currency_pair, :string
      add :debit, :integer
      add :credit, :integer
      add :rate, :decimal, precision: 9, scale: 4

      timestamps(updated_at: false, type: :utc_datetime)
    end

      create index(:transactions, [:user_id, :currency, "inserted_at DESC" ])

      create unique_index(:transactions, [:parent_id])
  end
end
