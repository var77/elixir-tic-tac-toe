defmodule XoValidation do
  use GenServer

  #  Client

  def valid_move?(room_id, cell) do
    {:ok, valid} = GenServer.call(:xo_validation, {:is_valid_move, room_id, cell})
    valid
  end

  def get_winner(players, cells) do
    {:ok, winner} = GenServer.call(:xo_validation, {:get_winner, players, cells})
    winner
  end

  #  Server

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: :xo_validation)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:is_valid_move, room_id, cell}, _from, state) do
    room = XoCache.get_room(room_id)
    valid = room.started && !room.finished && Enum.at(room.cells, cell) === 0
    {:reply, {:ok, valid}, state}
  end

  def handle_call({:get_winner, players, cells}, _from, state) do

    possibilites = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

    win_comb = Enum.find(possibilites, fn comb -> combination_is_won(comb, cells) end)

    winner = if win_comb do
      win_symbol = Enum.at(cells, Enum.at(win_comb, 0))
      Enum.find(players, &(&1.symbol === win_symbol)).id
    else nil
    end

    {:reply, {:ok, winner}, state}
  end

  def combination_is_won(comb, cells) do
    first = Enum.at(cells, Enum.at(comb, 0))
    second = Enum.at(cells, Enum.at(comb, 1))
    third = Enum.at(cells, Enum.at(comb, 2))

    first !== 0 && first === second && second === third
  end
end
