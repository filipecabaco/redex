defmodule RedisEcho.MixProject do
  use Mix.Project

  def project do
    [
      app: :redis,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Redis, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:redix, "~> 1.1"},
      {:castore, ">= 0.0.0"},
      {:ecto, "~> 3.11"}
    ]
  end
end
