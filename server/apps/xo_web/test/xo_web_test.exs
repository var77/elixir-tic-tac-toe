defmodule XoWebTest do
  use ExUnit.Case
  doctest XoWeb

  test "greets the world" do
    assert XoWeb.hello() == :world
  end
end
