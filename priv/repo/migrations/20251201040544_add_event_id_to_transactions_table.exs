defmodule CurrencyExchange.Repo.Migrations.AddEventIdToTransactionsTable do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :event_id, :string
    end
  end
end
