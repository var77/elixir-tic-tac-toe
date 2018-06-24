defmodule XoRoom do
  use Application
  use GenServer

  def start(_type, _opts), do: start_link(_opts)

  def start_link(_opts) do
    children = [
      XoTurn,
      XoValidation,
      XoRoom.Server
    ]

    Supervisor.start_link(children, [strategy: :one_for_one, name: XoRoom])
  end
end
