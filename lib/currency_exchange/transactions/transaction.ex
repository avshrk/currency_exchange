defmodule CurrencyExchange.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias CurrencyExchange.Accounts.User
  alias CurrencyExchange.Transactions.Transaction
  alias CurrencyExchange.Currencies

  schema "transactions" do
    field :currency, :string
    field :currency_pair, :string
    field :debit, :integer
    field :credit, :integer
    field :rate, :float
    field :balance, :integer

    belongs_to :user, User
    belongs_to :parent, Transaction, foreign_key: :parent_id
    has_one :child, Transaction, foreign_key: :parent_id

    timestamps(type: :utc_datetime)
  end


  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:currency, :currency_pair, :debit, :credit, :rate, :user_id, :parent_id])
    |> validate_required([:balance, :currency, :user_id])
    |> validate_inclusion(:currency, Currencies.list_all())
    |> validate_debit_credit()
    |> foreign_key_constraint(:parent_id)
    |> foreign_key_constraint(:user_id)
  end

  defp validate_debit_credit(changeset) do
    debit = get_field(changeset, :debit)
    credit = get_field(changeset, :credit)

    cond do
      is_nil(debit) and is_nil(credit) ->
        add_error(changeset, :base, "debit or credit must be provided")

      not is_nil(debit) and not is_nil(credit) ->
        add_error(changeset, :base, "only one of debit or credit must be provided")

      not is_nil(debit) and debit < 1 ->
        add_error(changeset, :debit, "Debit must be created than 0")

      not is_nil(credit) and credit < 1 ->
        add_error(changeset, :credit, "Debit must be created than 0")

      true ->
        changeset
    end
  end
end
