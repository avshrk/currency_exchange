defmodule CurrencyExchange.Repo.Migrations.AddNotNullConstraintToEventId do
  use Ecto.Migration

  @table_name :transactions
  @field_name :event_id

  def up do
    execute("ALTER TABLE #{@table_name} ALTER COLUMN #{@field_name} SET NOT NULL")
  end

  def down do
    execute("ALTER TABLE #{@table_name} ALTER COLUMN #{@field_name} DROP NOT NULL")
  end
end
