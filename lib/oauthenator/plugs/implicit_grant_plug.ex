defmodule Oauthenator.Plugs.ImplicitGrantPlug do
  use Oauthenator
  import Oauthenator.Controller
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn = %{assigns: %{current_user: nil}}, opts) do
    redirect(conn, to: login_path)
  end

  def call(conn = %{assigns: %{current_user: user}}, opts) do
    conn = fetch_query_params(conn)
    params = conn.query_params
    client_id = params["client_id"]
    case Repo.get_by(OauthClient, random_id: client_id) do
      nil ->
        conn |> send_resp(400, "Client not found")
      client ->
        {:ok, access_token} = Oauth.generate_access_token(client, user)
        redirect_url = "#{client.redirect_url}#access_token=#{access_token.token}&token_type=Bearer&state=#{params["state"]}"
        redirect(conn, external: redirect_url)
    end
  end

  defp login_path do
    Application.get_env(:oauthenator, :login_path)
  end

end
