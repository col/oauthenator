defmodule Oauthenator do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the Ecto repository
      supervisor(Oauthenator.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: Oauthenator.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
