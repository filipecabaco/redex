import Config

config :redex,
  ecto_repos: [Repo],
  generators: [timestamp_type: :utc_datetime]

config :redex, Repo, migration_primary_key: [name: :uuid, type: :binary_id]

import_config "#{Mix.env()}.exs"
