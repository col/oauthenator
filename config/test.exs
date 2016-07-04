use Mix.Config

config :oauthenator, Oauthenator.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "oauthenator_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
