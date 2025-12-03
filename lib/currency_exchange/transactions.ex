defmodule CurrencyExchange.Transactions do
  @moduledoc """
  The Transactions Context
  """
  import Ecto.Query, warn: false

  alias CurrencyExchange.Repo
  alias Ecto.Multi
  alias CurrencyExchange.Transactions.Transaction

  def get_transaction(transaction_id), do: Repo.get(Transaction, transaction_id)

  def currency_balance_by_user(%{user_id: user_id, currency: currency}) do
    currency_balance_by_user(user_id, currency)
  end

  def currency_balance_by_user(user_id, currency) do
    from(t in Transaction,
      where: t.user_id == ^user_id and t.currency == ^currency,
      order_by: [desc: t.inserted_at],
      select: t.balance,
      limit: 1
    )
    |> Repo.all()
    |> handle_balance_result()
  end

  defp handle_balance_result([]), do: 0
  defp handle_balance_result(result), do: hd(result)

  def all_currency_balances_by_user(user_id) do
    from(t in Transaction,
      where: t.user_id == ^user_id,
      distinct: [t.currency],
      order_by: [asc: t.currency, desc: t.inserted_at],
      select: %{currency: t.currency, balance: t.balance}
    )
    |> Repo.all()
  end

  def currencies_by_user(user_id) do
    from(t in Transaction,
      where: t.user_id == ^user_id,
      distinct: [:currency],
      select: t.currency
    )
    |> Repo.all()
  end

  def deposit_money(
    %{
      user_id: _user_id,
      currency: _currency,
      amount: amount
    } = attrs
  ) do
    current_balance = currency_balance_by_user(attrs)

    attrs = attrs
      |> Map.put(:balance, current_balance + amount)
      |> Map.put(:credit, amount)
      |> Map.put(:event_id, Ecto.UUID.generate())

    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def transfer_money(%{
    from_user_id: _from_user,
    to_user_id: _to_user,
    from_currency: _from_currency,
    to_currency: _to_currency,
    amount: _amount
  } = attrs) do
    attrs = Map.put(attrs, :event_id, Ecto.UUID.generate())

    multi = Multi.new()
      |> Multi.insert(:debit, debit_changeset(attrs))
      |> Multi.insert(
        :credit,
        fn %{debit: _debit_tx} ->
          credit_changeset(attrs)
      end)

    Repo.transaction(multi)
  end

  def build_changeset(
    %{
      user_id: _user_id,
      currency: _currency,
      event_id: _event_id,
      amount: amount
    } = base_attrs,
    type) do
    current_balance = currency_balance_by_user(base_attrs)

    {field, balance} =
      case type do
        :credit -> {:credit, current_balance + amount}
        :debit -> {:debit, current_balance - amount}
      end

    attrs =
      base_attrs
      |> Map.put(:balance, balance)
      |> Map.put(field, amount)

    Transaction.changeset(%Transaction{}, attrs)
  end

  def credit_changeset(
    %{
      to_user_id: user_id,
      to_currency: currency,
      event_id: event_id,
      amount: amount
    }
  ) do
    build_changeset(%{
      user_id: user_id,
      currency: currency,
      event_id: event_id,
      amount: amount
    }, :credit)
  end

  def debit_changeset(
    %{
      from_user_id: user_id,
      from_currency: currency,
      event_id: event_id,
      amount: amount
    }
  ) do
    build_changeset(%{
      user_id: user_id,
      currency: currency,
      event_id: event_id,
      amount: amount
    }, :debit)
  end
end
