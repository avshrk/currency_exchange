defmodule CurrencyExchange.Currencies do
  @app :currency_exchange
  @config_key :currencies

  def list_all() do
    Application.get_env(@app, @config_key, [])
  end

  def convert(from_cur, to_cur, amount) do
    amount * get_rate(from_cur, to_cur)
  end

  def get_rate(from_cur, to_cur) do
    # make a gen server call
    3
  end

  def all_pairs() do
    currencies = list_all()

    for x <- currencies, y <- currencies, x != y, do: "#{x}/#{y}"
  end
end
