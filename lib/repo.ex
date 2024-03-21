defmodule Repo do
  use Ecto.Repo,
    otp_app: :redex,
    adapter: Ecto.Adapters.Postgres
end
