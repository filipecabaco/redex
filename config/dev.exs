import Config

config :redex, Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "redis_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
