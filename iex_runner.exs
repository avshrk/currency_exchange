
alias CurrencyExchange.Transactions
alias CurrencyExchange.Transactions.Transaction
alias CurrencyExchange.Wallets.Wallet


#  1 | foo    | foo@email.com    | 2025-09-26 14:45:11
#  2 | bar    | bar@email.com    | 2025-09-26 14:45:37
#  3 | Alice  | alice@email.com  | 2025-09-26 15:46:01
#  6 | Bob    | bob@email.com    | 2025-09-30 20:29:32
#  7 | Buck   | buck@foo.com     | 2025-10-13 12:11:50
#  8 | Mark   | mark@email.com   | 2025-12-04 19:55:19
#  9 | Ernest | ernest@email.com | 2025-12-04 20:12:10



# Transactions.currency_balance_by_user(2, "CAD")

#CurrencyExchange.Wallets.Wallet.start_link(7)
#CurrencyExchange.Wallets.Wallet.upsert(7, "USD", 100)
#CurrencyExchange.Wallets.Wallet.upsert(7, "CAD", 200)
#CurrencyExchange.Wallets.Wallet.all(7)
#CurrencyExchange.Wallets.Wallet.by_currency(7, "USD")
#CurrencyExchange.Wallets.Wallet.by_currency(7, "noUSD")
#CurrencyExchange.Wallets.Wallet.all_currencies(7)



# Transactions.latest_transaction_by_user_by_currency(2, "iCAD")
# |> case do
#   nil -> 0
#   %{balance: balance} -> balance
# end
# |> IO.inspect()

# |> Wallet.from_transaction()

# CurrencyExchange.Transactions.transfer_money(from_wallet, to_wallet)

# CurrencyExchange.Transactions.deposit_money(wallet)


#  [1,2,3,6,7]
#  |> Enum.map( fn user_id ->
#      CurrencyExchange.Transactions.all_currency_balances_by_user(%{user_id: user_id})
#  end)
