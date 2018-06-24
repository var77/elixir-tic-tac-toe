defmodule XoRoom.Client do
  require GenServer
  def join_room(room_id, player_id) do
    GenServer.call(:xo_room, {:join_room, room_id, player_id})
  end

  def player_ready(room_id, player_id) do
    GenServer.call(:xo_room, {:player_ready, room_id, player_id})
  end

  def make_move(room_id, player_id, cell) do
    GenServer.call(:xo_room, {:make_move, room_id, player_id, cell})
  end

  def get_room_data(room_id) do
    {:ok, room } = GenServer.call(:xo_room, {:get_data, room_id})
    room
  end

  def remove_player_room(player_id) do
    GenServer.cast(:xo_room, {:remove_player_room, player_id})
  end
end