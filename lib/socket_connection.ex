defmodule SocketConnection do
  require Logger
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(%{port: port}) do
    opts = [mode: :binary, packet: :raw, active: false, reuseaddr: true]
    {:ok, socket} = :gen_tcp.listen(port, opts)
    {:ok, %{socket: socket}, {:continue, :accept}}
  end

  def handle_continue(:accept, state) do
    Process.send(self(), :accept, [])
    {:noreply, state}
  end

  def handle_info(:accept, %{socket: socket} = state) do
    {:ok, socket} = :gen_tcp.accept(socket)
    DynamicSupervisor.start_child(ConnectionSupervisor, {Connection, %{socket: socket}})
    Process.send(self(), :accept, [])
    {:noreply, state}
  end
end
