defmodule XoCache.Room do
  defstruct [:id, players: [], started: false, turn: 1, finished: false, winner: nil, cells: (for _ <- 1..9, do: 0)]
end