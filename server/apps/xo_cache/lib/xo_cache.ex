defmodule XoCache do
  use GenServer
  alias XoCache.Helpers
  ## Client

  def set_player(key, value) do
    IO.inspect value
    GenServer.call(:xo_cache, {:set, :players, key, value})
  end

  def set_room(key, value) do
    GenServer.call(:xo_cache, {:set, :rooms, key, value})
  end

  def get_player(key) do
    GenServer.call(:xo_cache, {:get, :players, key})
  end

  def get_room(key) do
    GenServer.call(:xo_cache, {:get, :rooms, key})
  end

  def get_waiting_rooms() do
    GenServer.call(:xo_cache, {:get_waiting_rooms})
  end

  ## Server

  def start_link(opts) do
#    case Keyword.fetch(opts, :name) do
#      {:ok, name} -> bucket_name = name
#      :error -> bucket_name = :xo_cache
#    end

    GenServer.start_link(__MODULE__, opts, name: :xo_cache)
  end

  def init(_opt) do
    table_opts = [:set, :protected, :named_table]
    rooms = :ets.new(:rooms, table_opts)
    players = :ets.new(:players, table_opts)

    state = {rooms, players}

    {:ok, state}
  end

  defp set_ets(table, key, value) do

    value = Helpers.string_keys_to_atoms(value)

    value =
      case table do
        :players -> struct(XoCache.Player, value)
        :rooms -> struct(XoCache.Room, value)
      end

    :ets.insert(table, {key, value})
  end

  defp get_ets(table, key) do
    case :ets.lookup(table, key) do
      [{^key, data}] -> data
      [] -> nil
    end
  end

  def handle_call({:set, table, key, value}, _from, {rooms, players}) do
    case set_ets(table, key, value) do
      true -> {:reply, :ok, {rooms, players}}
      _ -> {:reply, :error}
    end
  end

  def handle_call({:get, table, key}, _from, {rooms, players}) do
      {:reply, get_ets(table, key), {rooms, players}}
  end

  def handle_call({:get_waiting_rooms}, _from, _state) do

    # query = :ets.fun2ms(fn ({room_id, %{players: players, started: false }}) when length(players) == 2 -> {room_id, players} end)
    query = [ {{:"$1", %{players: :"$2", started: false}}, [{:==, {:length, :"$2"}, 2}], [{{:"$1", :"$2"}}]} ]

    waiting_rooms = :ets.select(:rooms, query)

    IO.inspect waiting_rooms

    Enum.each(waiting_rooms, fn ({ room_id, _}) ->
        room = get_ets(:rooms, room_id) |> Map.replace(:started, true) |> Map.from_struct
        set_ets(:rooms, room_id, room)
    end)

    {:reply, waiting_rooms, _state}
  end
end
