defmodule CurrencyExchange.Repo.Migrations.ChangeMoneyFieldsDataFormat do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      modify :debit, :string
      modify :credit, :string
      modify :balance, :string
    end

  end
end
