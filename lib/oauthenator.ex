defmodule Oauthenator do
  use Application

  defmacro __using__(_opts) do
    quote do
      alias Oauthenator.Oauth
      alias Oauthenator.Repo
      alias Oauthenator.Controller
      alias Oauthenator.User
      alias Oauthenator.OauthClient
      alias Oauthenator.OauthAccessToken
      alias Oauthenator.OauthAuthCode
      alias Oauthenator.OauthRefreshToken
    end
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      supervisor(Oauthenator.Repo, [])
    ]
    opts = [strategy: :one_for_one, name: Oauthenator.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
