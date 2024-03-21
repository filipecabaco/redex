defmodule MessageHandler do
  require Logger

  def handle({:ok, ["SELECT", _ref], _}) do
    {:ok, "+OK\r\n"}
  end

  def handle({:ok, ["PING"], _}) do
    {:ok, ["PONG"] |> Redix.Protocol.pack() |> IO.iodata_to_binary()}
  end

  def handle(err) do
    Logger.error("Unknown command: #{inspect(err)}")
    {:ok, "-ERR unknown command 'asdf'\r\n"}
  end
end
