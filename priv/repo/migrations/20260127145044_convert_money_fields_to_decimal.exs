defmodule CurrencyExchange.Repo.Migrations.ConvertMoneyFieldsToDecimal do
  use Ecto.Migration

  @table :transactions
  @fields ~w(debit credit balance)a
  @precision 12
  @scale 2

  def up do
    Enum.each(@fields, fn field ->
      execute("""
      ALTER TABLE #{@table}
      ALTER COLUMN #{field}
      TYPE numeric(#{@precision}, #{@scale})
      USING
        #{field}::numeric(#{@precision}, #{@scale}),
      ALTER COLUMN #{field} SET DEFAULT 0
      """)
    end)
  end

  def down do
    Enum.each(@fields, fn field ->
      execute("""
      ALTER TABLE #{@table}
      ALTER COLUMN #{field}
      TYPE text
      USING #{field}::text
      """)
    end)
  end
end
