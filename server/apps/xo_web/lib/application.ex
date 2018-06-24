defmodule XoWeb.Application do
  use Application

  def start(_type, _opts) do
    children = [
      XoCache,
      XoRoom,
      XoWeb.Endpoint,
    ]

    Supervisor.start_link(children, [strategy: :one_for_one, name: XoWeb.Application])
  end
end