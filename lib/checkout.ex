defmodule Checkout do
  @moduledoc """
  NoviCap's checkout process allows for items to be scanned in any order, and should return the total amount to be paid.
  """
  defstruct VOUCHER: nil, TSHIRT: nil, MUG: nil

  @type t :: %Checkout{VOUCHER: pid, TSHIRT: pid, MUG: pid}

  @spec scan(Checkout.t, string) :: Checkout.t
  def scan(items, code) do
    code
    |> String.to_existing_atom
    |> Item.add(items)
  end

  @spec total(Checkout.t) :: float
  def total(items) do
    items
    |> Map.from_struct
    |> Enum.filter(fn {_, pid} -> is_pid(pid) end)
    |> Enum.map(fn {_, pid} -> Item.total(pid) end)
    |> Enum.sum
  end
end
