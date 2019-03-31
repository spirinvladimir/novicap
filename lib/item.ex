defmodule Item do

  defstruct product: nil, count: 1

  @spec get_pid(atom) :: pid
  defp get_pid(code) do
    {:ok, pid} = Agent.start(fn ->
      %Item{product: Map.get(%Products{}, code)}
    end)
    pid
  end

  @spec add(atom, Checkout.t) :: Checkout.t
  def add(code, items) do
    pid = Map.get(items, code)
    if pid == nil do
      pid = get_pid(code)
      Map.put(items, code, pid)
    else
      Agent.update(pid, fn item ->
        Map.put(item, :count, item.count + 1)
      end)
      items
    end
  end

  @spec total(pid) :: float
  def total(pid) do
    bill = Agent.get(pid, &Rules.apply/1)
    Agent.stop(pid)
    bill
  end
end
