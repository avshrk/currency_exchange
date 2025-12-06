defmodule CurrencyExchange.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias CurrencyExchange.Accounts.User
  alias CurrencyExchange.Transactions.Transaction
  alias CurrencyExchange.Currencies

  schema "transactions" do
    field :currency, :string
    field :debit, :string
    field :credit, :string
    field :balance, :string
    field :event_id, :string

    belongs_to :user, User

    timestamps(type: :utc_datetime, updated_at: false)
  end

  @fields [:currency, :debit, :credit, :user_id, :balance, :event_id]

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @fields)
    |> validate_required([:balance, :currency, :user_id, :event_id])
    |> validate_inclusion(:currency, Currencies.list_all())
    |> validate_balance_value()
    |> validate_debit_credit_value()
    |> foreign_key_constraint(:user_id)
  end

  defp validate_balance_value(changeset) do
    balance =
      changeset
      |> get_field(:balance)
      |> Money.cast_decimal()

    cond do
      is_nil(balance) ->
        "Balance must me numeric string."

      Decimal.compare(balance, 0) == :lt ->
        "Balance must be equal or greater than 0"

      true ->
        changeset
    end
  end

  defp validate_debit_credit_value(changeset) do
    debit =
      changeset
      |> get_field(:debit)
      |> Money.cast_decimal()

    credit =
      changeset
      |> get_field(:credit)
      |> Money.cast_decimal()

    cond do
      is_nil(debit) and is_nil(credit) ->
        add_error(changeset, :base, "debit or credit must be numeric string")

      not is_nil(debit) and not is_nil(credit) ->
        add_error(changeset, :base, "only one of debit or credit must be provided")

      debit and Decimal.compare(debit, 0) == :lt ->
        add_error(changeset, :debit, "Debit must be greater than 0")

      credit and Decimal.compare(credit, 0) == :lt ->
        add_error(changeset, :credit, "Credit must be greater than 0")

      true ->
        changeset
    end
  end
end
