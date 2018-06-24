defmodule XoTurn do
  use GenServer

#  Client

  def valid_turn?(room_id, player_id) do
    {:ok, valid} = GenServer.call(:xo_turn, {:is_valid_turn, room_id, player_id})
    valid
  end

  def get_next_turn(room_id) do
    {:ok, turn} = GenServer.call(:xo_turn, {:get_next_turn, room_id})
    turn
  end

#  Server

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: :xo_turn)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:is_valid_turn, room_id, player_id}, _from, state) do
    room = XoCache.get_room(room_id)

    IO.puts "is_valid_turn room::"
    IO.inspect room
    IO.inspect player_id

    player = Enum.find(room.players, &(&1.id === player_id))
    valid = player.symbol === room.turn
    {:reply, {:ok, valid}, state}
  end

  def handle_call({:get_next_turn, room_id}, _from, state) do
    room = XoCache.get_room(room_id)
    turn = if room.turn === 1, do: 2, else: 1
    {:reply, {:ok, turn}, state}
  end


end
