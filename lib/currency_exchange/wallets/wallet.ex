defmodule CurrencyExchange.Wallets.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  alias CurrencyExchange.Transactions.Transaction
  alias CurrencyExchange.Currencies

  @primary_key false
  embedded_schema  do
    field :currency, :string
    field :balance, :integer
    field :user_id, :id
  end

  def build(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> apply_action(:insert)
  end

  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [:currency, :balance, :user_id])
    |> validate_required([:currency, :balance, :user_id])
    |> validate_inclusion(:currency, Currencies.list_all())
  end

  def from_transaction(%{currency: currency, balance: balance, user_id: user_id}) do
    %__MODULE__{
      currency: currency,
      balance: balance,
      user_id: user_id
    }
  end

  def from_transaction(%Transaction{} = tx) do
    from_transaction(%{
      currency: tx.currency,
      balance: tx.balance,
      user_id: tx.user_id
    })
  end
end
