defmodule Syncrojudge.MixProject do
  use Mix.Project

  def project do
    [
      app: :syncrojudge,
      version: "0.1.0",
      elixir: "~> 1.12",
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
      {:phoenix_live_view, "~> 1.1"},
      {:ecto_sql, "~> 3.13"},
      {:postgrex, "~> 0.19"},    # Driver do PostgreSQL exigido pelo Ecto
      {:oban, "~> 2.21"},
      {:ex_aws, "~> 2.6"},
      {:ex_aws_s3, "~> 2.5"},
      {:hackney, "~> 1.16"},     # HTTP client typically requested by ex_aws
      {:sweet_xml, "~> 0.7.5"}, # XML parser typically requested by ex_aws_s3
      {:bcrypt_elixir, "~> 3.3"},
      {:jason, "~> 1.4"}
    ]
  end
end
