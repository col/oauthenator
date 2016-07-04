use Mix.Config

config :oauthenator, Oauthenator.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "oauthenator_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
