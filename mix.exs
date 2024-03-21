defmodule Redex.MixProject do
  use Mix.Project

  def project do
    [
      app: :redex,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Redex, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:redix, "~> 1.1"},
      {:castore, ">= 0.0.0"},
      {:ecto, "~> 3.11"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"}
    ]
  end

  # Run "mix help aliases" to learn about aliases.
  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      setup: ["ecto.create --quiet", "ecto.migrate --quiet"]
    ]
  end
end
