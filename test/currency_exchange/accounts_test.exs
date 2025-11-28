defmodule CurrencyExchange.AccountsTest do
  use CurrencyExchange.DataCase

  alias CurrencyExchange.Accounts
  alias CurrencyExchange.Accounts.User
  alias CurrencyExchange.AccountsFixtures

  describe "@users" do



    test "list_users/0 returns all users" do
      user = AccountsFixtures.user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user/1 returns the user with given id" do
      user = AccountsFixtures.user_fixture()
      assert Accounts.get_user(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
       assert {:ok, %User{} = user} = Accounts.create_user(%{name: "Twain", email: "twain@email.com"})
       assert user.name == "Twain"
       assert user.email == "twain@email.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{name: nil, email: nil})
    end

    test "change_user/1 returns a user changeset" do
      user = AccountsFixtures.user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
