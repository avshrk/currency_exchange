defmodule CurrencyExchange.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias CurrencyExchange.Accounts.User
  alias CurrencyExchange.Transactions.Transaction
  alias CurrencyExchange.Currencies

  schema "transactions" do
    field :currency, :string
    field :debit, :integer
    field :credit, :integer
    field :balance, :integer
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
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> validate_debit_credit()
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

      is_nil(credit) and debit < 1 ->
        add_error(changeset, :debit, "Debit must be greater than 0")

      is_nil(debit) and credit < 1 ->
        add_error(changeset, :credit, "Credit must be greater than 0")

      true ->
        changeset
    end
  end
end
