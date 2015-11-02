defmodule PlugXForwardedFor.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_x_forwarded_for,
     version: "0.1.0",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{ :plug, "~> 1.0.2", only: [:dev, :test] },
     { :excheck, "~> 0.2.3", only: [:dev, :test] },
     { :triq, github: "krestenkrab/triq", only: [:dev, :test] },]
  end
end
