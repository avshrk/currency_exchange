defmodule CurrencyExchange.Currencies do
  @app :currency_exchange
  @config_key :currencies

  alias CurrencyExchange.Currencies.CurrencyPairRegistry
  alias CurrencyExchange.Currencies.CurrencyPairSupervisor
  alias CurrencyExchange.Currencies.CurrencyPair
  alias CurrencyExchange.Transactions
  alias CurrencyExchange.Money

  def list_all() do
    Application.get_env(@app, @config_key, [])
  end

  def convert(from_cur, to_cur, amount) do
    rate = get_rate(from_cur, to_cur)
    Money.convert_amount(amount, rate)
  end

  def get_rate(from_cur, to_cur) do
    from_cur
    |> build_pair(to_cur)
    |> CurrencyPair.value()
  end

  def build_pair(from_cur, to_cur), do: "#{from_cur}/#{to_cur}"

  def all_pairs() do
    currencies = list_all()

    for x <- currencies, y <- currencies, x != y, do: "#{x}/#{y}"
  end

  def create(cur_pair) do
    case CurrencyPair.pair_exists?(cur_pair) do
      false ->
        DynamicSupervisor.start_child(
          CurrencyPairSupervisor,
          {CurrencyPair, cur_pair}
        )

      _ ->
        :ok
    end
  end
end
