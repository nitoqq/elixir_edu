defmodule HomeFirstAidKit.MixProject do
  use Mix.Project

  def project do
    [
      app: :home_first_aid_kit,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:json, "~> 1.4"},
      {:poison, "~> 6.0"},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end
end
