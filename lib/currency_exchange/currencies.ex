defmodule CurrencyExchange.Currencies do
  @app :currency_exchange
  @config_key :currencies

  def list_all() do
    Application.get_env(@app, @config_key, [])
  end

  def all_pairs() do
    currencies = list_all()

    for x <- currencies, y <- currencies, x != y, do: "#{x}/#{y}"
  end
end
