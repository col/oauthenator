defmodule Oauthenator.Oauth do
  use Oauthenator
  use Timex

  def generate_access_token(%{id: client_id}, %{id: user_id}) do
    generate_access_token(client_id, user_id)
  end

  def generate_access_token(client_id, user_id) do
    OauthAccessToken.changeset(%OauthAccessToken{}, %{
      token: "ACCESS_CODE-EXAMPLE", # TODO: generate real access token
      expires_at: Timex.shift(DateTime.now, days: 30),
      user_id: user_id,
      oauth_client_id: client_id
    }) |> Repo.insert
  end

  def generate_auth_code(client_id, user_id) do
    OauthAuthCode.changeset(%OauthAuthCode{}, %{
      code: "AUTH-CODE-EXAMPLE", # TODO: generate real auth code
      expires_at: Timex.shift(DateTime.now, days: 30),
      user_id: user_id,
      oauth_client_id: client_id
    }) |> Repo.insert
  end

end
