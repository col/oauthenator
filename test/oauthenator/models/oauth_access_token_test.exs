defmodule Oauthenator.OauthAccessTokenTest do
  use ExUnit.Case
  use Timex
  alias Oauthenator.{Repo, OauthAccessToken}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Oauthenator.Repo)
  end

  describe "get_access_token" do
    setup do
      token = %OauthAccessToken{
        token: "token",
        expires_at: Timex.shift(DateTime.today, days: 30)
      } |> Repo.insert!
      {:ok, token: token}
    end

    test "should return a valid token", %{token: token} do
      result = OauthAccessToken.get_access_token("token", DateTime.today)
      assert result.id == token.id
    end

    test "should return nil for an unknown token" do
      result = OauthAccessToken.get_access_token("invalid-token", DateTime.today)
      assert result == nil
    end

    test "should return nil when the token has expired" do
      result = OauthAccessToken.get_access_token("token", Timex.shift(DateTime.today, days: 31))
      assert result == nil
    end
  end

end
