defmodule Oauthenator.OauthAccessTokenTest do
  use ExUnit.Case
  use Timex
  alias Oauthenator.{Repo, OauthAccessToken, OauthClient}

  @invalid_attrs %{}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Oauthenator.Repo)
    client = %OauthClient{random_id: "asdf", secret: "qwer", allowed_grant_types: "{}"} |> Repo.insert!
    valid_attrs = %{token: "token", expires_at: DateTime.today, oauth_client_id: client.id}
    {:ok, valid_attrs: valid_attrs}
  end

  test "changeset with valid attributes", %{valid_attrs: valid_attrs} do
    changeset = OauthAccessToken.changeset(%OauthAccessToken{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = OauthAccessToken.changeset(%OauthAccessToken{}, @invalid_attrs)
    refute changeset.valid?
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
