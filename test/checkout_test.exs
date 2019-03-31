defmodule CheckoutTest do
  use ExUnit.Case
  doctest Checkout

  test "VOUCHER, TSHIRT, MUG = 32.50€" do
    total = %Checkout{}
    |> Checkout.scan("VOUCHER")
    |> Checkout.scan("TSHIRT")
    |> Checkout.scan("MUG")
    |> Checkout.total

    assert total == 32.50
  end

  test "VOUCHER, TSHIRT, VOUCHER = 25.00€" do
    total = %Checkout{}
    |> Checkout.scan("VOUCHER")
    |> Checkout.scan("TSHIRT")
    |> Checkout.scan("VOUCHER")
    |> Checkout.total

    assert total == 25.00
  end

  test "TSHIRT, TSHIRT, TSHIRT, VOUCHER, TSHIRT = 81.00€" do
    total = %Checkout{}
    |> Checkout.scan("TSHIRT")
    |> Checkout.scan("TSHIRT")
    |> Checkout.scan("TSHIRT")
    |> Checkout.scan("VOUCHER")
    |> Checkout.scan("TSHIRT")
    |> Checkout.total

    assert total == 81.00
  end

  test "VOUCHER, TSHIRT, VOUCHER, VOUCHER, MUG, TSHIRT, TSHIRT = 74.50€" do
    total = %Checkout{}
    |> Checkout.scan("VOUCHER")
    |> Checkout.scan("TSHIRT")
    |> Checkout.scan("VOUCHER")
    |> Checkout.scan("VOUCHER")
    |> Checkout.scan("MUG")
    |> Checkout.scan("TSHIRT")
    |> Checkout.scan("TSHIRT")
    |> Checkout.total

    assert total == 74.50
  end
end
