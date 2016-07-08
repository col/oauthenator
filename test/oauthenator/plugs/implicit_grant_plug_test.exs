defmodule Oauthenator.Plugs.ImplicitGrantPlugTest do
  use ExUnit.Case
  use Plug.Test
  use Oauthenator
  alias Oauthenator.Plugs.ImplicitGrantPlug

  @options ImplicitGrantPlug.init([])

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Oauthenator.Repo)
    Application.put_env(:oauthenator, :login_path, "/login")
    :ok
  end

  describe "when user authenticated" do
    setup do
      %OauthClient{random_id: "1234", secret: "asdf", allowed_grant_types: "{}", redirect_url: "http://www.example.com/authorized"} |> Repo.insert!
      user = %User{email: "test@example.com", password: "12345"} |> Repo.insert!
      conn = conn(:get, "/blah?client_id=1234&state=some-state")
        |> assign(:current_user, user)
      {:ok, conn: conn}
    end

    test "implicit grant", %{conn: conn} do
      conn = ImplicitGrantPlug.call(conn, @options)

      assert conn.state == :sent
      assert conn.status == 302
      expected_url = "http://www.example.com/authorized#access_token=1234ABCD&token_type=Bearer&state=some-state"
      assert Plug.Conn.get_resp_header(conn, "location") == [expected_url]
    end
  end

  describe "when user not authenticated" do
    setup do
      conn = conn(:get, "/") |> assign(:current_user, nil)
      {:ok, conn: conn}
    end

    test "redirect to login", %{conn: conn} do
      conn = ImplicitGrantPlug.call(conn, @options)

      assert conn.state == :sent
      assert conn.status == 302
      assert Plug.Conn.get_resp_header(conn, "location") == ["/login"]
    end
  end

  describe "when client not found" do
    setup do
      user = %User{email: "test@example.com", password: "12345"} |> Repo.insert!
      conn = conn(:get, "/blah?client_id=1234&state=some-state") |> assign(:current_user, user)
      {:ok, conn: conn}
    end

    test "implicit grant", %{conn: conn} do
      conn = ImplicitGrantPlug.call(conn, @options)

      assert conn.state == :sent
      assert conn.status == 400
      assert conn.resp_body == "Client not found"
    end
  end

end
