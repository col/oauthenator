defmodule Oauthenator.OauthClientTest do
  use ExUnit.Case
  use Timex
  alias Oauthenator.OauthClient

  @valid_attrs %{random_id: "asdf", secret: "qwer", allowed_grant_types: "{}"}
  @invalid_attrs %{}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Oauthenator.Repo)
  end

  test "changeset with valid attributes" do
    changeset = OauthClient.changeset(%OauthClient{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = OauthClient.changeset(%OauthClient{}, @invalid_attrs)
    refute changeset.valid?
  end

end
