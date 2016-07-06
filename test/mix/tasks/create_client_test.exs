defmodule Mix.Tasks.Oauthenator.CreateClientTest do
  use ExUnit.Case

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Oauthenator.Repo)
  end

  test "with no args" do
    Mix.Tasks.Oauthenator.CreateClient.run([])
    client = Oauthenator.Repo.all(Oauthenator.OauthClient) |> List.first
    assert client != nil
    assert client.name == nil
    assert client.random_id != nil
    assert client.secret != nil
    assert client.redirect_url == nil
    assert client.allowed_grant_types == "{}"
  end

  test "with --name" do
    Mix.Tasks.Oauthenator.CreateClient.run(["--name", "Testing"])
    client = Oauthenator.Repo.all(Oauthenator.OauthClient) |> List.first
    assert client != nil
    assert client.name == "Testing"
  end

  test "with --redirect-url" do
    Mix.Tasks.Oauthenator.CreateClient.run(["--redirect-url", "http://www.example.com"])
    client = Oauthenator.Repo.all(Oauthenator.OauthClient) |> List.first
    assert client != nil
    assert client.redirect_url == "http://www.example.com"
  end

  test "with --password" do
    Mix.Tasks.Oauthenator.CreateClient.run(["--password"])
    client = Oauthenator.Repo.all(Oauthenator.OauthClient) |> List.first
    assert client != nil
    assert client.allowed_grant_types == "{\"password\":true}"
  end

  test "with --client-credentials" do
    Mix.Tasks.Oauthenator.CreateClient.run(["--client-credentials"])
    client = Oauthenator.Repo.all(Oauthenator.OauthClient) |> List.first
    assert client != nil
    assert client.allowed_grant_types == "{\"client_credentials\":true}"
  end

  test "with --refresh-token" do
    Mix.Tasks.Oauthenator.CreateClient.run(["--refresh-token"])
    client = Oauthenator.Repo.all(Oauthenator.OauthClient) |> List.first
    assert client != nil
    assert client.allowed_grant_types == "{\"refresh_token\":true}"
  end

end
