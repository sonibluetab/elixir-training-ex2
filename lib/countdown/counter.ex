defmodule Countdown.Counter do
  @moduledoc false
  @limit 100

  def start_link do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  def limit do
    @limit
  end

  def value do
    Agent.get( __MODULE__, fn c -> c end )
  end

  def count do
    cond do
     value + 1 >= limit ->
        set(0)
        {:overflow, value}
     true ->
        set(value + 1)
        {:ok, value}
    end
  end

  def reset do
    set(0)
  end

  def set(val) do
    Agent.update(__MODULE__, fn _n -> val end)
  end
end