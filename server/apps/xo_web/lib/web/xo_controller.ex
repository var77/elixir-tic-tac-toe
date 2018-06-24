defmodule XoWeb.Controller do
  use Phoenix.Controller, namespace: TestPhxWeb
  import Plug.Conn
  def index(conn, _params) do
    send_resp(conn, 404, "Not found")
  end
end
