defmodule Countdown.ArenaChannel do
  @moduledoc false
  use Phoenix.Channel

  alias Countdown.Counter

  def join("arenas:lobby", _message, socket) do
    {:ok, %{counter: Counter.value}, socket}
  end

  def join("arenas:" <> _any, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("count", payload, socket) do
    countRes = case Counter.count do
      {:overflow, val} -> %{won: true, value: val}
      {:ok, val} -> %{won: false, value: val}
    end
    broadcast! socket, "update", %{counter: countRes.value}
     {:reply, {:ok,  %{won: countRes.won, counter: countRes.value}}, socket}
  end

  def handle_in("update", %{counter: c}, socket) do
    Counter.set(c)
    {:noreply, socket}

  end
  
end