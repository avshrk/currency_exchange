defmodule CurrencyExchange.Transactions do
  @moduledoc """
  The Transactions Context
  """
  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias CurrencyExchange.Repo
  alias CurrencyExchange.Transactions.Transaction
  alias CurrencyExchange.Wallets
  alias CurrencyExchange.Money

  def all_currency_balances_by_user(user_id) do
    from(t in Transaction,
      where: t.user_id == ^user_id,
      distinct: [t.currency],
      order_by: [asc: t.currency, desc: t.inserted_at],
      select: %{currency: t.currency, balance: t.balance}
    )
    |> Repo.all()
  end

  def create_deposit(user_id, currency, amount) do
    event_id = Ecto.UUID.generate()

    %{user_id: user_id, currency: currency, amount: amount}
    |> build_changeset(event_id, :credit)
    |> Repo.insert()
  end

  def create_transfer(from_user_id, to_user_id, currency, amount) do
    balance = Wallets.balance_by_currency(from_user_id, currency)

    case Money.compare(balance, amount) == :lt do
      true ->
        {:error, message: "Not enough funds!"}

      _ ->
        create_transfer(
          %{user_id: from_user_id, currency: currency, amount: amount},
          Wallets.to_wallet(to_user_id, currency, amount)
        )
    end
  end

  defp create_transfer(from_tran, to_tran) do
    event_id = Ecto.UUID.generate()

    Multi.new()
    |> Multi.insert(:debit, build_changeset(from_tran, event_id, :debit))
    |> Multi.insert(:credit, fn %{debit: _debit} ->
      build_changeset(to_tran, event_id, :credit)
    end)
    |> Repo.transaction()
    |> IO.inspect()
    # |> Wallets.update()
  end

  def build_changeset(
        %{amount: amount, user_id: user_id, currency: currency} = trans,
        event_id,
        type
      ) do
    current_balance = latest_transaction_by_user_by_currency(user_id, currency) || "0"

    {field, balance} =
      case type do
        :credit ->
          {:credit, Money.calculate_amount(current_balance, amount, :add)}

        :debit ->
          {:debit, Money.calculate_amount(current_balance, amount, :sub)}
      end

    attrs =
      trans
      |> Map.put(:event_id, event_id)
      |> Map.put(:balance, balance)
      |> Map.put(field, amount)

    Transaction.changeset(%Transaction{}, attrs)
  end

  defp latest_transaction_by_user_by_currency(user_id, currency) do
    from(t in Transaction,
      where: t.user_id == ^user_id and t.currency == ^currency,
      order_by: [desc: t.inserted_at],
      select: t.balance,
      limit: 1
    )
    |> Repo.all()
    |> List.first()
  end
end
