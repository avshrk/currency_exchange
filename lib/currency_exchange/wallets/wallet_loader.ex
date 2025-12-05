defmodule CurrencyExchange.Wallets.WalletLoader do

  alias CurrencyExchange.Accounts
  alias CurrencyExchange.Wallets
  alias CurrencyExchange.Wallets.Wallet
  alias CurrencyExchange.Transactions

  def load_all() do
    users = Accounts.list_users()
    create_user_wallets(users)
    load_user_wallets(users)
  end

  def create_user_wallets(users) do
    Enum.each(
      users,
      fn user -> Wallets.create(user.id)
    end)
  end

  def load_user_wallets(users) do
    users
    |> Enum.each(fn %{id: user_id}->
      user_id
      |> Transactions.all_currency_balances_by_user()
      |> Enum.each( fn %{currency: currency, balance: balance}->
        Wallets.update(user_id, currency, balance)
      end)
    end)
  end
end
