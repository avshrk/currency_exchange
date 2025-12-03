defmodule CurrencyExchange.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string

    has_many :transactions, CurrencyExchange.Transactions.Transaction

    timestamps(type: :utc_datetime, updated_at: false)
  end

  @doc false
  def changeset(user, attrs) do
    attrs = attrs
      |> Map.update(:name, nil, &(&1 && String.trim(&1)))
      |> Map.update(:email, nil, &(&1 && String.trim(&1)))

    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_length(:name, min: 2, max: 100 )
    |> validate_length(:email, min: 5, max: 200 )
    |> unique_constraint(:email)
  end
end
