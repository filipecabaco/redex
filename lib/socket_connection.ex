defmodule SocketConnection do
  require Logger
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(%{port: port}) do
    {:ok, socket} =
      :gen_tcp.listen(port, mode: :binary, packet: :raw, active: false, reuseaddr: true)

    Logger.info("Accepting connections on port #{port}")
    {:ok, socket} = :gen_tcp.accept(socket)

    {:ok, %{socket: socket}, {:continue, :accept}}
  end

  def handle_continue(:accept, %{socket: socket} = state) do
    DynamicSupervisor.start_child(ConnectionSupervisor, {Connection, %{socket: socket}})

    {:noreply, state, {:continue, :accept}}
  end
end
