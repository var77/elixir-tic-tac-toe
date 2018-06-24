defmodule XoWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:" <> room_id, _auth_msg, socket) do
    IO.puts "Join room from player " <> socket.assigns.player_id <> " to room " <> room_id
    player = XoCache.get_player socket.assigns.player_id
    if player.room_id do
        {:ok, assign(socket, :room_id, room_id)}
      else
        case XoRoom.Client.join_room(room_id, socket.assigns.player_id) do
          {:ok, _room} -> {:ok, assign(socket, :room_id, room_id)}
          {:error, _reason } -> {:error, %{}}
        end
    end
  end

  def handle_in("room.ready", _data, socket) do
    case XoRoom.Client.player_ready(socket.assigns.room_id, socket.assigns.player_id) do
      {:ok, room} ->
        broadcast(socket, "room.player.ready", %{player_id: socket.assigns.player_id})
        check_room_start(room, socket)
        {:noreply, socket}
      _ -> {:noreply, socket}
    end
  end

  def handle_in("room.move", data, socket) do
    player_id = socket.assigns.player_id
    room_id = socket.assigns.room_id

    case XoRoom.Client.make_move(room_id, player_id, data["cell"]) do
      {:ok, cells, turn, winner} -> broadcast(socket, "room.make.move", %{player_id: player_id, cells: cells, winner: winner, turn: turn})
      {:error} -> broadcast(socket, "room.make.move", %{error: "Invalid move"})
    end

    {:noreply, socket}
  end

  defp check_room_start(room, socket) do
    IO.puts("Room.started ====>")
    IO.inspect(room)

    if room.started, do: broadcast(socket, "room.start", room)
  end

end