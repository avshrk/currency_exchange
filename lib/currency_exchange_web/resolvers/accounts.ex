defmodule CurrencyExchangeWeb.Resolvers.Accounts do
  alias CurrencyExchange.Accounts

  def user(_, %{id: id}, _) do
    case Accounts.get_user(id) do
      nil -> {:error, "not found"}
      user -> {:ok, user}
    end
  end

  def users(_, _, _), do: {:ok, Accounts.list_users()}

  def create_user(_, args, _) do
    case Accounts.create_user(args) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
