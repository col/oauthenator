defmodule Oauthenator.Mixfile do
  use Mix.Project

  def project do
    [app: :oauthenator,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps()]
  end

  def application do
    [
      applications: [:logger, :postgrex, :ecto, :timex, :timex_ecto, :poison],
      mod: {Oauthenator, []}
    ]
  end

  defp deps do
    [{:postgrex, ">= 0.0.0"},
     {:ecto, "~> 2.0.0"},
     {:timex, "~> 2.2.1"},
     {:timex_ecto, "~> 1.1.3"},
     {:poison, "~> 1.5 or ~> 2.0"}]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

end
