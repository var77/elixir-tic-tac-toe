defmodule XoWeb.Router do
  use Phoenix.Router

  get "/*path", XoWeb.Controller, :index
end
