defmodule ApponeTest do
  use ExUnit.Case
  doctest Appone

  test "greets the world" do
    assert Appone.hello() == :world
  end
end
