defmodule Athena.MixProject do
  use Mix.Project

  def project do
    [
      app: :athena,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      source_url: "https://gitlab.com/distortia/athena"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description() do
    "An ANSI to HTML converter. Built for the usage of Cucumber output."
  end

  defp package() do
    [
      name: "athena",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Nick Stalter", "Jeremy Gardner"],
      licenses: ["MIT"],
      links: %{"GitLab" => "https://gitlab.com/distortia/athena"}
    ]
  end
end
