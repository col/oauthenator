defmodule Oauthenator.OauthTest do
  use ExUnit.Case
  alias Oauthenator.{Oauth, Repo, OauthClient, User, OauthAuthCode}

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Oauthenator.Repo)
    client = %OauthClient{random_id: "asdf", secret: "qwer", allowed_grant_types: "{}"} |> Repo.insert!
    user = %User{email: "test@example.com", password: "111111"} |> Repo.insert!
    {:ok, client: client, user: user}
  end

  test "generate_auth_code", %{client: client, user: user} do
    {:ok, auth_code} = Oauth.generate_auth_code(client.id, user.id)
    assert auth_code.code == "AUTH-CODE-EXAMPLE"
    assert auth_code.oauth_client_id == client.id
    assert auth_code.user_id == user.id
  end

end
