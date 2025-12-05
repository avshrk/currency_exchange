defmodule CurrencyExchange.Wallets.Wallet do
  use Agent

  alias CurrencyExchange.Wallets.WalletRegistry

  def start_link(user_id) do
    Agent.start_link(fn -> %{} end, name: via(user_id))
  end

  def upsert(user_id, currency, amount) do
    Agent.update(via(user_id), &Map.put(&1, currency, amount))
  end

  def all(user_id) do
    Agent.get(via(user_id), & &1)
  end

  def by_currency(user_id, currency) do
    Agent.get(via(user_id), & &1[currency])
  end

  def currency_exists?(user_id, currency) do
    by_currency(user_id, currency) != nil
  end

  def empty?(user_id) do
    all(user_id) === %{}
  end

  def highest_amount_currency(user_id) do
    Agent.get(via(user_id), &Enum.max_by(&1, fn {_k, v } -> v end ))
  end

  def all_currencies(user_id) do
    Agent.get(via(user_id), &Map.keys(&1))
  end

  def user_exists?(user_id) do
    case Registry.lookup(WalletRegistry, user_id) do
      [] -> false
      _ -> true
    end
  end

  defp via(user_id) do
    {:via, Registry, {WalletRegistry, user_id}}
  end
end
