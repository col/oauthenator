defmodule Oauthenator.OauthAuthCodeTest do
  use ExUnit.Case
  use Timex
  alias Oauthenator.{Repo, OauthAuthCode, OauthClient}

  @invalid_attrs %{}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Oauthenator.Repo)
    client = %OauthClient{random_id: "asdf", secret: "qwer", allowed_grant_types: "{}"} |> Repo.insert!
    valid_attrs = %{code: "code", expires_at: DateTime.today, oauth_client_id: client.id}
    {:ok, valid_attrs: valid_attrs}
  end

  test "changeset with valid attributes", %{valid_attrs: valid_attrs} do
    changeset = OauthAuthCode.changeset(%OauthAuthCode{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = OauthAuthCode.changeset(%OauthAuthCode{}, @invalid_attrs)
    refute changeset.valid?
  end

  describe "get_access_token" do
    setup do
      auth_code = %OauthAuthCode{
        code: "code",
        expires_at: Timex.shift(DateTime.today, days: 30)
      } |> Repo.insert!
      {:ok, auth_code: auth_code}
    end

    test "should return a valid token", %{auth_code: auth_code} do
      result = OauthAuthCode.get_auth_code("code", DateTime.today)
      assert result.id == auth_code.id
    end

    test "should return nil for an unknown code" do
      result = OauthAuthCode.get_auth_code("invalid-code", DateTime.today)
      assert result == nil
    end

    test "should return nil when the code has expired" do
      result = OauthAuthCode.get_auth_code("code", Timex.shift(DateTime.today, days: 31))
      assert result == nil
    end
  end

end
