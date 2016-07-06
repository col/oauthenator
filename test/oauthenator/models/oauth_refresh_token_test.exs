defmodule Oauthenator.OauthRefreshTokenTest do
  use ExUnit.Case
  use Timex
  alias Oauthenator.{Repo, OauthRefreshToken, OauthClient}

  @invalid_attrs %{}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Oauthenator.Repo)
    client = %OauthClient{random_id: "asdf", secret: "qwer", allowed_grant_types: "{}"} |> Repo.insert!
    valid_attrs = %{token: "token", expires_at: DateTime.today, is_delete: false, oauth_client_id: client.id}
    {:ok, valid_attrs: valid_attrs}
  end

  test "changeset with valid attributes", %{valid_attrs: valid_attrs} do
    changeset = OauthRefreshToken.changeset(%OauthRefreshToken{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = OauthRefreshToken.changeset(%OauthRefreshToken{}, @invalid_attrs)
    refute changeset.valid?
  end

end
