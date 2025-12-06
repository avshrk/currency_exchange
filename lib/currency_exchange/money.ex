defmodule CurrencyExchange.Money do
  def convert_amount(amount, rate) do
    case cast_decimal([amount, rate]) do
      false ->
        nil

      true ->
        calculate_amount(amount, rate, :mul)
    end
  end

  def compare(amount_a, amount_b) do
    Decimal.compare(amount_a, amount_b)
  end

  def calculate_amount(from_amount, to_amount, type) do
    IO.inspect to_amount
    amount =
      case type do
        :add -> Decimal.add(from_amount, to_amount)
        :sub -> Decimal.sub(from_amount, to_amount)
        :mul -> Decimal.mult(from_amount, to_amount)
      end

    round_and_convert_string(amount)
  end

  def round_and_convert_string(amount) do
    amount
    |> Decimal.round(2, :half_up)
    |> Decimal.to_string(:normal)
  end

  def cast_decimal(vals) when is_list(vals) do
    Enum.all?(vals, &cast_decimal/1)
  end

  def cast_decimal(val) do
    case Decimal.cast(val) do
      :error -> nil
      {:ok, _} -> val
    end
  end
end
