attrs = %{
  from_user_id: 1,
  to_user_id: 3,
  amount: 10000,
  from_currency: "USD",
  to_currency: "USD"
}

attrs = %{
  user_id: 3,
  currency: "EUR",
  amount: 100
}

  CurrencyExchange.Transactions.deposit_money(attrs)

# CurrencyExchange.Transactions.all_currency_balances_by_user(3)
