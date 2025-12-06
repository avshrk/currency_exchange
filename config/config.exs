# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :currency_exchange,
  ecto_repos: [CurrencyExchange.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :currency_exchange, CurrencyExchangeWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: CurrencyExchangeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: CurrencyExchange.PubSub,
  live_view: [signing_salt: "mnQ6wsZ9"]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :currency_exchange,
  currencies: ["AUD","CAD","EUR","GBP", "USD"]

config :currency_exchange,
  fetch_url: "http://localhost:4001/query?function=CURRENCY_EXCHANGE_RATE"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
