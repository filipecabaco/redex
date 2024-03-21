defmodule Redis do
  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, name: ConnectionSupervisor},
      {SocketConnection, %{port: 6379}}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
