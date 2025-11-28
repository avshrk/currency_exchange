defmodule CurrencyExchange.Transactions do
  @moduledoc """
  The Transactions Context
  """

  import Ecto.Query, warn: false
  alias CurrencyExchange.Repo

  alias CurrencyExchange.Transactions.Transaction

  def get_transaction(transaction_id), do: Repo.get(Transaction, transaction_id)

  def currency_balance_by_user(user_id, currency) do
    from(t in Transaction,
      where: t.user_id == ^user_id and t.currency == ^currency,
      order_by: [desc: t.inserted_at],
      select: t.balance,
      limit: 1
    )
  end

  def all_currency_balances_by_user(user_id) do
    from(t in Transaction,
      where: t.user_id == ^user_id,
      distinct: [t.currency],
      order_by: [asc: t.currency, desc: t.inserted_at],
      select: %{currency: t.currency, balance: t.balance}
    )
  end

  def currencies_by_user(user_id) do
    from(t in Transaction,
      where: t.user_id == ^user_id,
      distinct: [:currency],
      select: t.currency
    )
    |> Repo.all()
  end

  def create_transaction(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end
end
