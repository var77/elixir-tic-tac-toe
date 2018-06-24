defmodule XoWeb.UserChannel do
  use Phoenix.Channel

  def join("user:" <> player_id, _auth_msg, socket) do
      if socket.assigns.player_id === player_id do
        {:ok, socket}
      else
        {:error}
      end
  end

  def handle_in("user.welcome", _data, socket) do
    player_id = socket.assigns.player_id
    case XoCache.get_player(player_id) do
      nil -> {:reply, :ok, nil}
      player ->
        if player.room_id do
          case XoRoom.Client.get_room_data(player.room_id) do
             nil -> XoCache.set_player(player_id, Map.put(player, :room_id, nil))
             room -> broadcast(assign(socket, "room_id", room.id), "user.welcome", room)
          end
        end
        {:noreply, socket}
    end
  end

end