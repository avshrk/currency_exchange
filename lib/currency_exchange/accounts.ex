defmodule CurrencyExchange.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias CurrencyExchange.Repo

  alias CurrencyExchange.Accounts.User
  alias CurrencyExchange.Wallets

  def list_users do
    Repo.all(User)
  end

  def get_user(id), do: Repo.get(User, id)

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> create_user_wallet()
  end

  defp create_user_wallet({:ok, %User{id: user_id}}) do
    Wallets.create(user_id)
  end

  defp create_user_wallet(error), do: error
end
