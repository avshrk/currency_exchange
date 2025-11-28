import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :currency_exchange, CurrencyExchange.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "currency_exchange_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :currency_exchange, CurrencyExchangeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "CkCEDoFa5GgJGzV90aeVn7o1H0hZpIo/1AW+5RlLOLiWk1FA4G5s43pA6SkxI+Vn",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
