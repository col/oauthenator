# oauthenator

OAuth2 Provider - Work In Progress

## Setup

- Add dependency
- Add Oauthenator.Repo config

```
config :oauthenator, Oauthenator.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "<apps db name>",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
```

- Add Oauthenator.Repo to your apps list of repos

```
config :oauthenator_app, ecto_repos: [OauthenatorApp.Repo, Oauthenator.Repo]
```

- Generate a oauth client record

```
mix oauthenator.create_client --name Example --authorization_code --redirect-url http://lvh.me:4500/auth/oauthenator/callback
```
