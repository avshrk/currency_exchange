defmodule CurrencyExchange.Repo do
  use Ecto.Repo,
    otp_app: :currency_exchange,
    adapter: Ecto.Adapters.Postgres
end
