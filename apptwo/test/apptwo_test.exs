defmodule ApptwoTest do
  use ExUnit.Case
  doctest Apptwo

  test "greets the world" do
    assert Apptwo.hello() == :world
  end
end
