defmodule KitchTest do
  use ExUnit.Case
  doctest Kitch

  test "greets the world" do
    assert Kitch.hello() == :world
  end
end
