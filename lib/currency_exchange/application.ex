defmodule CurrencyExchange.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CurrencyExchange.Repo,
      {DNSCluster, query: Application.get_env(:currency_exchange, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CurrencyExchange.PubSub},
      CurrencyExchangeWeb.Endpoint,
      {Absinthe.Subscription, CurrencyExchangeWeb.Endpoint},
      {Registry, keys: :unique, name: CurrencyExchange.Wallets.WalletRegistry},
      {DynamicSupervisor, strategy: :one_for_one, name: CurrencyExchange.Wallets.WalletSupervisor},
      {Registry, keys: :unique, name: CurrencyExchange.Currencies.CurrencyPairRegistry},
      {DynamicSupervisor, strategy: :one_for_one, name: CurrencyExchange.Currencies.CurrencyPairSupervisor},
      Supervisor.child_spec(
        {Task, fn ->
          CurrencyExchange.Wallets.WalletLoader.load_all()
          CurrencyExchange.Currencies.CurrencyLoader.load_currency_pairs()
        end},
        id: :startup_loader
      ),
  {CurrencyExchange.Currencies.CurrencyFetcherService, CurrencyExchange.Currencies.all_pairs() }
    ]

    opts = [strategy: :one_for_one, name: CurrencyExchange.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    CurrencyExchangeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
