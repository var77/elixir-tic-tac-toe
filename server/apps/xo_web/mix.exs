defmodule XoWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :xo_web,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :cowboy, :plug],
      mod: {XoWeb.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:poison, "~> 3.1.0"},
      {:phoenix, "~> 1.3.1"},
      {:phoenix_pubsub, "~> 1.0"},
      {:xo_cache, in_umbrella: true},
    ]
  end
end
