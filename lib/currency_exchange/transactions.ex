defmodule CurrencyExchange.Transactions do
  @moduledoc """
  The Transactions Context
  """
  import Ecto.Query, warn: false

  alias CurrencyExchange.Repo
  alias Ecto.Multi
  alias CurrencyExchange.Transactions.Transaction
  alias CurrencyExchange.Wallets.Wallet

  def all_currency_balances_by_user(user_id) do
    from(t in Transaction,
      where: t.user_id == ^user_id,
      distinct: [t.currency],
      order_by: [asc: t.currency, desc: t.inserted_at],
      select: %{currency: t.currency, balance: t.balance}
    )
    |> Repo.all()
  end

  def deposit_money(user_wallet) do
    event_id = Ecto.UUID.generate()

    user_wallet
    |> build_changeset(event_id, :credit)
    |> Repo.insert()
  end

  def transfer_money(
        %{user_id: form_user_id, currency: from_currency, amount: _from_amount} = from_wallet,
        %{user_id: to_user_id, currency: to_currency, amount: _to_amount} = to_wallet
      ) do
    event_id = Ecto.UUID.generate()
    IO.inspect from_wallet
    IO.inspect to_wallet

    Multi.new()
    |> Multi.insert(:debit, build_changeset(from_wallet, event_id, :debit))
    |> Multi.insert(:credit, fn %{debit: _debit} ->
      build_changeset(to_wallet, event_id, :credit)
    end)
    |> Repo.transaction()
  end

  def build_changeset(
        %{amount: amount, user_id: user_id, currency: currency} = wallet,
        event_id,
        type
      ) do
    current_balance = currency_balance_by_user(user_id, currency)

    {field, balance} =
      case type do
        :credit -> {:credit, current_balance + amount}
        :debit -> {:debit, current_balance - amount}
      end

    attrs =
      wallet
      |> Map.put(:event_id, event_id)
      |> Map.put(:balance, balance)
      |> Map.put(field, amount)

    Transaction.changeset(%Transaction{}, attrs)
  end

  defp latest_transaction_by_user_by_currency(user_id, currency) do
    from(t in Transaction,
      where: t.user_id == ^user_id and t.currency == ^currency,
      order_by: [desc: t.inserted_at],
      limit: 1
    )
    |> Repo.all()
    |> List.first()
  end

  defp currency_balance_by_user(user_id, currency) do
    latest_transaction_by_user_by_currency(user_id, currency)
    |> case do
      nil -> 0
      %{balance: balance} -> balance
    end
  end

  # goes into agent
  #   def currencies_by_user(user_id) do
  #     from(t in Transaction,
  #       where: t.user_id == ^user_id,
  #       distinct: [:currency],
  #       select: t.currency
  #     )
  #     |> Repo.all()
  #   end
end
