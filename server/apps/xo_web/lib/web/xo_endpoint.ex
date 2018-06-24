defmodule XoWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :xo_web

  socket "/socket", XoWeb.Socket

  plug XoWeb.Router

  plug Phoenix.CodeReloader

  def init(_key, config) do
    {:ok, config}
  end
end