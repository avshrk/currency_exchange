defmodule CurrencyExchangeWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :currency_exchange
  use Absinthe.Phoenix.Endpoint

  @session_options [
    store: :cookie,
    key: "_currency_exchange_key",
    signing_salt: "3XJfNq2J",
    same_site: "Lax"
  ]

  socket "/socket", Absinthe.Phoenix.Socket,
    websocket: true,
    longpoll: false

  plug Plug.Static,
    at: "/",
    from: :currency_exchange,
    gzip: not code_reloading?,
    only: CurrencyExchangeWeb.static_paths()

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :currency_exchange
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug CurrencyExchangeWeb.Router
end
