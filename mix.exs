defmodule RinhaCalado.MixProject do
  use Mix.Project

  def project do
    [
      app: :rinha_calado,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
      mod: {RinhaCalado.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.6"},
      {:postgrex, "~> 0.17.3"},
      {:jason, "~> 1.4"},
      {:poison, "~> 5.0"},
      {:nebulex, "~> 2.5"},
      {:libcluster, "~> 3.3"},
      { :uuid, "~> 1.1" }
    ]
  end
end
