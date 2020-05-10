defmodule Coercion.Mixfile do
  use Mix.Project

  def project do
    [
      app: :coercion,
      version: "1.2.1",
      elixir: "~> 1.3",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Package
      name: "Coercion",
      package: package(),
      description: description(),
      source_url: "https://github.com/moxley/coercion",
      docs: [
        # The main page in the docs
        main: "Coercion",
        extras: ["README.md"]
      ]
    ]
  end

  def application, do: []

  def deps do
    [
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Coerce and validate dirty values to Elixir primitives.
    """
  end

  defp package do
    [
      name: :coercion,
      maintainers: ["Moxley Stratton"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/moxley/coercion"}
    ]
  end
end
