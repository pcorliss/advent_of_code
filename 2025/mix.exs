defmodule Aoc2025.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc_2025,
      version: "0.1.0",
      elixir: "~> 1.19.3",
      start_permanent: Mix.env() == :prod,
      deps: [
        {:briefly, "~> 0.5.1"}
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end
end
