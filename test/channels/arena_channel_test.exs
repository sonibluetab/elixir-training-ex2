defmodule Countdown.ArenaChannelTest do
  use Countdown.ChannelCase, async: true

   alias Countdown.{ArenaChannel, UserSocket, Counter}

   setup do
     # Ensure counter starts with 0
     Counter.reset
     on_exit fn -> Counter.reset end

     # Get socket
     {:ok, socket} = connect(UserSocket, %{})
     # And join main channel
     {:ok, reply, socket} = subscribe_and_join(socket, ArenaChannel, "arenas:lobby")

     {:ok, socket: socket, join_reply: reply}
   end

   test "should reply counter, 0 the first time, when joining", %{join_reply: reply} do
     assert %{counter: 0} = reply
   end

   test "should reply updated counter when joining" do
     # Increment counter
     Counter.count
     # Create new socket and join to the channel
     {:ok, socket} = connect(UserSocket, %{})
     {:ok, reply, _socket} = subscribe_and_join(socket, "arenas:lobby")
     # So it should reply updated counter
     assert %{counter: 1} = reply
   end
  #
   test "count broadcasts updated counter to arenas:lobby", %{socket: socket} do
     # At this moment counter value should be 0
     assert 0 = Counter.value
     # Then, when sending "count" event to channel it should update counter (to 1)
     ref = push socket, "count", %{}
     # And should broadcast updated counter to all channel members
     assert_broadcast "update", %{counter: 1}
     # Replying the counter
     assert_reply ref, :ok, %{won: false, counter: 1}
     # Let's ensure counter has been updated here
     assert 1 = Counter.value
     # NOTE: this last assertion could fail if called just after "push" call.
     # That's because "push" method only sends the "count" message to the
     # channel, and the channel (that runs in *another process*) will dispatch it
     # when it can do it. Sooner than later, but doen's have to be immediately.
   end
end
