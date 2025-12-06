defmodule CurrencyExchange.Currencies.CurrencyFetcherService do
  use GenServer

  alias CurrencyExchange.Currencies
  alias CurrencyExchange.Currencies.CurrencyLoader

  @interval :timer.seconds(10)
  @short_interval :timer.seconds(4)
  @name __MODULE__

  def start_link(cur_pairs) do
    GenServer.start_link(@name, cur_pairs, name: @name)
  end

  def init(cur_pairs) do
    schedule_fetch(@short_interval)
    {:ok, cur_pairs}
  end

  def handle_info(:fetch_rates, cur_pairs) do
    fetch_now(cur_pairs)

    schedule_fetch()

    {:noreply, cur_pairs}
  end

  defp fetch_now(cur_pairs)  do
    Enum.each(cur_pairs, fn cur_pair ->
      Task.start(CurrencyLoader, :update_currency_pair, [cur_pair ])
    end)
  end

  defp schedule_fetch(interval \\ @interval ) do
    Process.send_after(self(), :fetch_rates, interval)
  end

end
