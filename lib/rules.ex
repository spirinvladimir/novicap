defmodule Rules do
  @moduledoc """
  Any discounts or offers or special price should be here
  """

  @doc """
  Apply buissines rules for product
  At first apply buissines one by one then calculate default price
  """
  def apply(item) do
    product = item.product
    code = product.code
    price = product.price
    count = item.count
    0
    |> two_for_one(code, price, count)
    |> buy_three_or_more(code, count)
    |> default(price, count)
  end

  @doc """
  In case no rules for product: price * count
  """
  @spec default(float, float, integer) :: float
  def default(bill, price, count) do
    case bill do
      0 -> price * count
      _ -> bill
    end
  end

  @doc """
  The marketing department believes in 2-for-1 promotions (buy two of the same product, get one free), and would like for there to be a 2-for-1 special on VOUCHER items.
  """
  @voucher %Voucher{}.code
  @spec two_for_one(float, atom, float, integer) :: float
  def two_for_one(bill, code, price, count) do
    if code == @voucher do
      if rem(count, 2) == 0 do
        bill + price * count / 2
      else
        ## Do rule for odd count only
        ## Example: rule(*****) -> rule(****) + (*) -> (**) + (*)
        bill + price * (1 + (count - 1) / 2)
      end
    else
      bill
    end
  end

  @doc "The CFO insists that the best way to increase sales is with discounts on bulk purchases (buying x or more of a product, the price of that product is reduced), and demands that if you buy 3 or more TSHIRT items, the price per unit should be 19.00€."
  @tshirt %Tshirt{}.code
  @spec buy_three_or_more(float, atom, integer) :: float
  def buy_three_or_more(bill, code, count) do
    case code do
      @tshirt ->
        case count >= 3 do
          true -> bill + 19.00 * count
          _ -> bill
        end
      _ -> bill
    end
  end
end
