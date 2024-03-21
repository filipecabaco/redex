Mix.install([:redix])
defmodule RedisEchoTest do
  def run() do
    {:ok, conn} =
      Redix.start_link("redis://localhost:6379/3",
        sync_connect: true,
        exit_on_disconnection: true
      )
      |> IO.inspect(label: :connected)

    Redix.command(conn, ["PING"]) |> IO.inspect(label: :ping)
    conn
  end
end

_conn = IO.inspect(RedisEchoTest.run(), label: :conn)
