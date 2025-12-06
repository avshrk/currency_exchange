defmodule CurrencyExchange.Currencies.CurrencyPair do
  use Agent

  alias CurrencyExchange.Currencies.CurrencyPairRegistry

  def start_link(cur_pair) do
    Agent.start_link(fn -> "0" end, name: via(cur_pair))
  end

  def set(cur_pair, amount) do
    Agent.update(via(cur_pair), fn _ -> amount end)
  end

  def value(cur_pair) do
    Agent.get(via(cur_pair), fn state -> state end)
  end

  def update(cur_pair, amount) do
    Agent.get_and_update(via(cur_pair), fn state -> {state, amount} end)
  end

  def pair_exists?(cur_pair) do
    case Registry.lookup(CurrencyPairRegistry, cur_pair) do
      [] -> false
      _ -> true
    end
  end

  defp via(cur_pair) do
    {:via, Registry, {CurrencyPairRegistry, cur_pair}}
  end
end
