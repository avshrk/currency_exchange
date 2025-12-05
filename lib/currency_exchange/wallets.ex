defmodule CurrencyExchange.Wallets do
  alias CurrencyExchange.Wallets.Wallet
  alias CurrencyExchange.Wallets
  alias CurrencyExchange.Transactions
  alias CurrencyExchange.Wallets.WalletSupervisor
  alias CurrencyExchange.Currencies

  def currencies_by_user(user_id) do
    Wallet.all_currencies(user_id)
  end

  def wallet_balance(user_id, currency) do
    Wallet.by_currency(user_id, currency)
  end

  def wallet_balances(user_id) do
    Wallet.all(user_id)
  end

  def deposit(user_id, currency, amount) do
    %{user_id: user_id, currency: currency, amount: amount}
    |> Transactions.deposit_money()
    |> update(user_id, currency, amount)
  end

  def update({:error, _} = error, _user_id, _currency, _amount), do: error

  def update({:ok, _}, user_id, currency, amount) do
    update(user_id, currency, amount)
  end

  def update(user_id, currency, amount) do
    Wallet.upsert(user_id, currency, amount)
  end

  def currency_to_convert(user_id) do
    Wallet.highest_amount_currency(user_id)
  end

  def total_value_by_currency(user_id, to_currency) do
    user_id
    |> Wallet.all()
    |> Enum.reduce(0, fn {from_currency, amount}, acc ->
      case  from_currency === to_currency do
        true -> acc + amount
        _ -> acc + Currencies.convert(from_currency, to_currency, amount)
      end
    end)
  end

  def send_money(from_user_id, to_user_id, currency, amount) do
    balance = wallet_balance(from_user_id, currency)

    case balance >= amount do
      true ->
        from_wallet = %{user_id: from_user_id, currency: currency, amount: amount}
        to_wallet = to_wallet(%{user_id: to_user_id, currency: currency, amount: amount})
        Transactions.transfer_money(from_wallet, to_wallet)

        _ -> {:error, message: "Not enough funds!"}
    end
  end

  def to_wallet(%{user_id: user_id, currency: currency, amount: amount} = wallet_data) do
     cond do
      Wallet.currency_exists?(user_id, currency) || Wallet.empty?(user_id) ->
        wallet_data
      true ->
        {to_currency, _amount} = currency_to_convert(user_id)
        converted_amount = Currencies.convert(currency, to_currency, amount)
        %{user_id: user_id, currency: to_currency, amount: converted_amount}
     end
  end

  def create(user_id) do
    case Wallet.user_exists?(user_id) do
      false -> DynamicSupervisor.start_child(WalletSupervisor, {Wallet, user_id})
      _ -> :ok
    end
  end
end
