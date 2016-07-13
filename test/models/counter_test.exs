defmodule Countdown.CounterTest do
  use ExUnit.Case, async: true

   alias Countdown.Counter

   setup do
     Counter.reset # This method should set the count to 0. Otherwise no test will work.
     # NOTE: To make tests working you need to uncomment lib/countdown.ex:13
     # line when creating Countdown.Counter module to make process available
     # globaly.

     on_exit fn -> Counter.reset end

     :ok
   end

   test "starts with 0 as value" do
     assert 0 = Counter.value
   end

   test "has a limit of 100" do
     assert 100 = Counter.limit
   end

   test "incrementing counter, being under limit, returns its value" do
     assert {:ok, 1} = Counter.count
     assert {:ok, 2} = Counter.count
     assert {:ok, 3} = Counter.count
   end

   test "incrementing counter, when in limit, returns overflow and 0 as count" do
     Counter.set(Counter.limit - 1)
     assert {:overflow, 0} = Counter.count
   end

   test "resets count" do
     Counter.count
     Counter.count
     Counter.reset
     assert 0 = Counter.value
   end

   test "sets count to a given value" do
     Counter.set(42)
     assert 42 = Counter.value
   end
end
