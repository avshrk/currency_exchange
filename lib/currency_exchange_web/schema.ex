defmodule CurrencyExchangeWeb.Schema do
  use Absinthe.Schema

  alias CurrencyExchangeWeb.Resolvers
  import_types Absinthe.Type.Custom

  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)
    # field :wallets, list_of(:wallets)
  end

  # object :wallet do
  # field :currency, non_null(:string)
  #   field :balance, non_null(:integer)
  #  field :user_id, non_nill(:id)
  #  end

  query do
    field :user, :user do
      arg :id, non_null(:id)
      resolve &Resolvers.Accounts.user/3
    end

    field :users, non_null(list_of(non_null(:user))) do
      resolve &Resolvers.Accounts.users/3
    end

    # field :wallet, :wallet do
    # arg :user_id, non_null(:id)
      # resolve &Resolvers.Wallets.
    # end
  end

  mutation do
    field :create_user, :user do
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      resolve &Resolvers.Accounts.create_user/3
    end
  end
end
