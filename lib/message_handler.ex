defmodule MessageHandler do
  require Logger

  def handle({:ok, ["SELECT", ref], _}, state) do
    db =
      case ref do
        "0" -> Logged
        _ -> Unlogged
      end

    {:ok, "+OK\r\n", %{state | db: db}}
  end

  def handle({:ok, ["PING"], _}, state) do
    pong =
      ["PONG"]
      |> Redix.Protocol.pack()
      |> IO.iodata_to_binary()

    {:ok, pong, state}
  end

  def handle({:ok, ["SET", key, value], _}, state) do
    Redex.insert(state.db, key, value)
    {:ok, "+OK\r\n", state}
  end

  def handle({:ok, ["GET", key], _}, state) do
    value =
      case Redex.get(state.db, key) do
        nil -> nil
        %{value: value} -> value
      end

    reply =
      [value]
      |> Redix.Protocol.pack()
      |> IO.iodata_to_binary()

    {:ok, reply, state}
  end

  def handle({:ok, ["EXISTS", key], _}, state) do
    value = if Redex.exists(state.db, key), do: 1, else: 0

    reply =
      [value]
      |> Redix.Protocol.pack()
      |> IO.iodata_to_binary()

    {:ok, reply, state}
  end

  def handle({:ok, ["DEL", key], _}, state) do
    Redex.delete(state.db, key)
    {:ok, "+OK\r\n", state}
  end

  def handle({_, [cmd | _], _} = parsed, state) do
    Logger.error("Unsupported command: #{inspect(parsed)}")
    {:ok, "-ERR unsupported command '#{cmd}'\r\n", state}
  end
end
