ExUnit.start()

Mix.Task.run "ecto.create", ~w(-r Oauthenator.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Oauthenator.Repo --quiet)

Ecto.Adapters.SQL.Sandbox.mode(Oauthenator.Repo, :manual)
