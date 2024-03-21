Mix.install([:redix])

defmodule RedexTest do
  def run() do
    {:ok, conn} = Redix.start_link("redis://localhost:6379", []) |> IO.inspect()
    Redix.command(conn, ["PING"]) |> IO.inspect()
    conn
  end
end

conn = RedexTest.run()
# Check error condition for unsupported commands
Redix.command(conn, ["POTATO"]) |> IO.inspect()
Redix.command(conn, ["SET", "foo", "foo"]) |> IO.inspect()
Redix.command(conn, ["GET", "bar"]) |> IO.inspect()
Redix.command(conn, ["GET", "foo"]) |> IO.inspect()
Redix.command(conn, ["EXISTS", "bar"]) |> IO.inspect()
Redix.command(conn, ["EXISTS", "foo"]) |> IO.inspect()
Redix.command(conn, ["DEL", "foo"]) |> IO.inspect()
Redix.command(conn, ["EXISTS", "foo"]) |> IO.inspect()
