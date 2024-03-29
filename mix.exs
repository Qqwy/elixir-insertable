defmodule Insertable.Mixfile do
  use Mix.Project

  def project do
    [app: :insertable,
     version: "1.0.0",
     elixir: "~> 1.9",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     consolidate_protocols: Mix.env != :test, # Required until elixir-lang/elixir#6270 is fixed.
     deps: deps(),
     name: "Insertable",
     description: description(),
     source_url: "https://github.com/Qqwy/elixir-insertable",
     package: package(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [
       coveralls: :test,
       "coveralls.detail": :test,
       "coveralls.post": :test,
       "coveralls.html": :test
     ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:type_check, "~> 0.8"},
      {:ex_doc, "~> 0.14", only: :dev},
      {:excoveralls, "~> 0.10", only: :test},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end

  defp description() do
    """
    A lightweight reusable Insertable protocol, allowing insertion elements one-at-a-time into a collection.
    """
  end

  defp package() do
    [
      name: :insertable,
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Qqwy/Wiebe-Marten Wijnja"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/Qqwy/elixir-insertable"}
    ]
  end
end
