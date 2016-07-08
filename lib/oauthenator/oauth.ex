defmodule Oauthenator.Oauth do
  use Oauthenator
  use Timex

  def generate_access_token(client, user) do
    OauthAccessToken.changeset(%OauthAccessToken{}, %{
      token: "1234ABCD",
      expires_at: Timex.shift(DateTime.now, days: 30),
      user_id: user.id,
      oauth_client_id: client.id
    }) |> Repo.insert
  end

end
