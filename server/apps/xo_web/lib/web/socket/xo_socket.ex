defmodule XoWeb.Socket do
  use Phoenix.Socket
  transport :websocket, Phoenix.Transports.WebSocket

  channel "room:*", XoWeb.RoomChannel
  channel "user:*", XoWeb.UserChannel

  def connect(params, socket) do
    player = params["token"] |> Base.url_decode64! |> Poison.decode!

    if !XoCache.get_player(player["id"]), do: XoCache.set_player(player["id"], player)

    {:ok, assign(socket, :player_id, player["id"])}
  end

  def id(socket), do: nil#socket.assigns.player_id
end