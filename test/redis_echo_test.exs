defmodule RedisEchoTest do
  use ExUnit.Case
  doctest RedisEcho

  test "greets the world" do
    assert RedisEcho.hello() == :world
  end
end
