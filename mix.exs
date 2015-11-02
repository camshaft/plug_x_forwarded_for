defmodule PlugXForwardedFor.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_x_forwarded_for,
     description: "x-forwarded-for plug middleware",
     version: "0.1.0",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{ :plug, "~> 1.0.2", only: [:dev, :test] },
     { :excheck, "~> 0.2.3", only: [:dev, :test] },
     { :triq, github: "krestenkrab/triq", only: [:dev, :test] },]
  end

  defp package do
    [files: ["lib", "mix.exs", "README*"],
     maintainers: ["Cameron Bytheway"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/camshaft/plug_x_forwarded_for"}]
  end
end
