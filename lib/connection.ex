defmodule Connection do
  use GenServer
  require Logger
  defstruct [:socket, :db]

  def start_link(%{socket: socket}) do
    GenServer.start_link(__MODULE__, %__MODULE__{socket: socket}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state, {:continue, :read}}
  end

  def handle_continue(:read, state) do
    Process.send(self(), :read, [])
    {:noreply, state}
  end

  def handle_info(:read, %{socket: socket} = state) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, packet} ->
        Logger.debug("Received: #{inspect(packet)}")

        {:ok, reply, state} =
          packet
          |> Redix.Protocol.parse()
          |> MessageHandler.handle(state)

        :ok = :gen_tcp.send(socket, reply)
        Process.send(self(), :read, [])

        {:noreply, state}

      _ ->
        {:stop, :normal, state}
    end
  end

  def handle_info({:tcp_closed, port}, state) do
    Logger.info("Connection closed: #{inspect(port)}")
    {:stop, :normal, state}
  end

  def handle_info(msg, state) do
    Logger.info(inspect(msg))
    {:noreply, state}
  end
end
