defmodule CurrencyExchange.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias CurrencyExchange.Repo

  alias CurrencyExchange.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user(id), do: Repo.get(User, id)

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
