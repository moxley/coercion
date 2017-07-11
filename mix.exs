defmodule Coersion.Mixfile do
  use Mix.Project

  def project do
    [
      app: :coersion,
      version: "1.0.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),

      # Package
      name: "Coersion",
      package: package(),
      description: description(),
      source_url: "https://github.com/househappy/coersion",
      docs: [
        main: "Coersion", # The main page in the docs
        extras: ["README.md"]
      ],
    ]
  end

  def application, do: []

  def deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    A tool for coercing and validating dirty values to Elixir primitives.
    """
  end

  defp package do
    # These are the default files included in the package
    [
      name: :coersion,
      files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Moxley Stratton"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/househappy/coersion"}
    ]
  end
end
