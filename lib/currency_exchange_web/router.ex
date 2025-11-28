defmodule CurrencyExchangeWeb.Router do
  use CurrencyExchangeWeb, :router

  pipeline :graphql do
    plug :accepts, ["json"]
  end

  pipeline :graphiql do
    plug :accepts, ["html"]
  end

  scope "/" do
    pipe_through :graphql
    forward "/graphql",
      Absinthe.Plug,
      schema: CurrencyExchangeWeb.Schema
  end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through :graphiql
      forward "/graphiql",
        Absinthe.Plug.GraphiQL,
        schema: CurrencyExchangeWeb.Schema,
        interface: :playground,
        socket: Absinthe.Phoenix.Socket,
        socket_url: "/socket"
    end
  end
end
