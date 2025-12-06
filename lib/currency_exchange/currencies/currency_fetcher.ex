defmodule CurrencyExchange.Currencies.CurrencyFetcher do

  @app :currency_exchange
  @config_key :fetch_url

  def fetch_rate(cur_pair) do
    [from_cur, to_cur] = String.split(cur_pair, "/")
    fetch_rate(from_cur, to_cur)
  end

  def fetch_rate(from_cur, to_cur) do
    params = %{
      function: "CURRENCY_EXCHANGE_RATE",
      from_currency: from_cur,
      to_currency: to_cur
    }

    Req.get(url: url(), params: params)
    |> handle_response()
  end

  def handle_response({:error, error_data }), do: error_data

  def handle_response({ :ok,
    %Req.Response{
      body: %{
        "Realtime Currency Exchange Rate" => %{ "5. Exchange Rate" => rate }
      }
    }
  }) do
      rate
  end

  def url do
    Application.get_env(@app, @config_key, "")
  end
end
