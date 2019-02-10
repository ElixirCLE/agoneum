defmodule Agoneum.Mixfile do
  use Mix.Project

  def project do
    [app: :agoneum,
     version: "0.0.1",
     elixir: "~> 1.5",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Agoneum.Application, []},
     extra_applications: [:logger, :runtime_tools, :scout_apm, :ueberauth,
                          :ueberauth_facebook, :ueberauth_google, :ueberauth_identity]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
     {:canada, "~> 1.0.1"},
     {:canary, "~> 1.1.0"},
     {:comeonin, "~> 3.0.0"},
     {:cowboy, "~> 1.0"},
     {:gettext, "~> 0.11"},
     {:guardian, "~> 0.14.4"},
     {:phoenix, "~> 1.3.0"},
     {:phoenix_ecto, "~> 3.2"},
     {:phoenix_html, "~> 2.10"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:phoenix_slime, "~> 0.10.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:plug_cowboy, "~> 1.0"},
     {:postgrex, ">= 0.0.0"},
     {:scout_apm, "~> 0.4"},
     {:ueberauth, "~> 0.4"},
     {:ueberauth_facebook, "~> 0.6"},
     {:ueberauth_google, "~> 0.5"},
     {:ueberauth_identity, "~> 0.2.3"},

     {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
   ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     s: ["phx.server"],
     test: ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
