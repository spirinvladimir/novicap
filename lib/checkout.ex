defmodule Checkout do
  @moduledoc """
  NoviCap's checkout process allows for items to be scanned in any order, and should return the total amount to be paid.
  """
  defstruct VOUCHER: nil, TSHIRT: nil, MUG: nil

  @type t :: %Checkout{VOUCHER: pid, TSHIRT: pid, MUG: pid}

  @doc """
  items is a map product type -> pid. For each type of product there is a separate process
  This is a way of CPU scaling at checkout app.
  """
  @spec scan(Checkout.t, string) :: Checkout.t
  def scan(items, code) do
    code
    |> String.to_existing_atom
    |> Item.add(items)
  end

  @doc """
  Function total should be executed once in general after all scans and before buy.
  It seems no sence to cache total result at each scan.
  Here is classic MapReduce pattern for parallel calculation a price rules per product(I mean CFO rulse, etc)
  """
  @spec total(Checkout.t) :: float
  def total(items) do
    items
    |> Map.from_struct
    |> Enum.filter(fn {_, pid} -> is_pid(pid) end)
    |> Enum.map(fn {_, pid} -> Item.total(pid) end)
    |> Enum.sum
  end
end
