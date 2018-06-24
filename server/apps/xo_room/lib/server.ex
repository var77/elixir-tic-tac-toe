defmodule XoRoom.Server do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: :xo_room)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:get_data, room_id}, _from, state) do
    room = XoCache.get_room(room_id)
    room = if room.finished, do: nil, else: room

    {:reply, {:ok, room}, state}
  end

  def handle_call({:join_room, room_id, player_id}, _from, state) do
    player = XoCache.get_player(player_id)

    room = case XoCache.get_room(room_id) do
      nil ->
        XoCache.set_room(room_id, %{id: room_id})
        XoCache.get_room(room_id)
      room -> room
    end


    players_length = length(room.players)


    if(players_length < 2 && player && !Enum.find(room.players, &(&1.id == player_id))) do

      symbol = if (players_length === 1), do: 2, else: 1

      player_data = Map.from_struct(player) |> Map.put(:symbol, symbol) |> Map.put(:ready, false)

      room = Map.put(room, :players, [ player_data | room.players])

      IO.puts "Room is"
      IO.inspect room
      IO.puts "======"

      XoCache.set_room(room_id, room |> Map.from_struct)
      XoCache.set_player(player_id, Map.put(player, :room_id, room_id))
      {:reply, {:ok, room}, state}

    else
      {:reply, {:error, "/No room/No space in room/No such player/Player already in room"}, state}
    end

  end

  def handle_call({:player_ready, room_id, player_id}, _from, state) do
    case XoCache.get_room(room_id) do
      nil -> {:reply, {:error, "Room not found"}}
      room ->
        player = Enum.find(room.players, &(&1.id === player_id))
        cond do
          !player ->  {:reply, {:error, "already said ready"}, state}
          player.ready -> {:reply, {:error, "already said ready"}, state}
          true ->
            player =  Map.put(player, :ready, true)
            player_index = Enum.find_index(room.players, fn  room_player -> room_player.id === player_id end)
            players = List.replace_at(room.players, player_index, player)
            started = Enum.filter(players, fn room_player -> room_player.ready end) |> length === 2
            room = Map.put(room, :players, players) |> Map.put(:started, started)
            XoCache.set_room(room_id, room)
            {:reply, {:ok, room}, state}
        end


    end
  end

  def handle_call({:make_move, room_id, player_id, cell}, _from, state) do
    is_valid_turn = XoTurn.valid_turn?(room_id, player_id)
    is_valid_move = XoValidation.valid_move?(room_id, cell)

    IO.puts "is_valid_move:: "
    IO.inspect is_valid_move
    IO.puts "is_valid_turn:: "
    IO.inspect is_valid_turn

    if(!is_valid_move || !is_valid_turn) do
      {:reply, {:error}, state}
    else
      room = XoCache.get_room(room_id)
      player = Enum.find(room.players, &(&1.id === player_id))
      cells = List.replace_at(room.cells, cell, player.symbol)

      room = Map.put(room, :cells, cells)

      turn = XoTurn.get_next_turn(room_id)
      winner = XoValidation.get_winner(room.players, cells)

      room = Map.put(room, :turn, turn) |> Map.put(:winner, winner)

      room = if winner do
        Enum.each(room.players, fn room_player -> remove_player_room(room_player.id) end)
        Map.put(room, :finished, true)
      else
        room
      end

      IO.puts "room after move:: "
      IO.inspect room

      XoCache.set_room(room_id, room)

      {:reply, {:ok, cells, turn, winner}, state}
    end

  end

  def handle_cast({:remove_player_room, player_id}, state) do
    remove_player_room(player_id)
    {:noreply, state}
  end

  defp remove_player_room(player_id) do
    cache_player = XoCache.get_player(player_id) |> Map.put(:room_id, nil)
    XoCache.set_player(player_id, cache_player)
  end

  defp _room_job() do
#    TODO:: For dynamic room creation
     rooms = XoCache.get_waiting_rooms()
#    Enum.each(rooms, fn ({room_id, players}) -> XoWeb.Socket end)
  end
end