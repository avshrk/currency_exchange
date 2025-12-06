defmodule CurrencyExchange.Currencies.CurrencyLoader do
  alias CurrencyExchange.Currencies
  alias CurrencyExchange.Currencies.CurrencyPair
  alias CurrencyExchange.Currencies.CurrencyFetcher

  def load_currency_pairs() do
    currency_pairs = Currencies.all_pairs()
    Enum.each(currency_pairs, &Currencies.create/1)
    # Enum.each(currency_pairs, &update_currency_pair/1)
  end

  def update_currency_pair(cur_pair) do
    new_rate = CurrencyFetcher.fetch_rate(cur_pair)
    cur_rate = CurrencyPair.update(cur_pair, new_rate)
    if new_rate != cur_rate do
      IO.inspect("#{cur_pair}: #{cur_rate} -> #{new_rate}")
      # trigger subscription currency change
    end
  end
end
