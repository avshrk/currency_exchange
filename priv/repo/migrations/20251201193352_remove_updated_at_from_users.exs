defmodule CurrencyExchange.Repo.Migrations.RemoveUpdatedAtFromUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :updated_at, :utc_datetime
    end
  end
end
