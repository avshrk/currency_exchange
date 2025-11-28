defmodule CurrencyExchange.AccountsFixtures do
  @moduledoc """
  Accounts test helper functions.
  """

  def unique_user_email, do: "email#{System.unique_integer([:positive])}"
  def unique_user_name, do: "name#{System.unique_integer([:positive])}"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        name: unique_user_name()
      })
      |> CurrencyExchange.Accounts.create_user()

    user
  end
end
