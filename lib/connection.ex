defmodule Connection do
  use GenServer
  require Logger

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:ok, state, {:continue, :read}}
  end

  def handle_continue(:read, %{socket: socket} = state) do
    Logger.info("Waiting...")

    case :gen_tcp.recv(socket, 0) do
      {:ok, packet} ->
        Logger.info("Received: #{inspect(packet)}")

        {:ok, reply} =
          packet
          |> Redix.Protocol.parse()
          |> MessageHandler.handle()

        :ok = :gen_tcp.send(socket, reply)

        {:noreply, state, {:continue, :read}}

      _ ->
        {:stop, :normal, state}
    end
  end

  def handle_info({:tcp_closed, port}, state) do
    Logger.info("Connection closed: #{inspect(port)}")
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.info(inspect(msg))
    {:noreply, state}
  end
end
