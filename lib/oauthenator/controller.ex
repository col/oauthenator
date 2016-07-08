defmodule Oauthenator.Controller do
  import Plug.Conn

  @doc """
  Sends redirect response to the given url.
  For security, `:to` only accepts paths. Use the `:external`
  option to redirect to any URL.
  ## Examples
      iex> redirect conn, to: "/login"
      iex> redirect conn, external: "http://elixir-lang.org"
  """
  def redirect(conn, opts) when is_list(opts) do
    url  = url(opts)
    html = Plug.HTML.html_escape(url)
    body = "<html><body>You are being <a href=\"#{html}\">redirected</a>.</body></html>"

    conn
    |> put_resp_header("location", url)
    |> send_resp(conn.status || 302, "text/html", body)
  end

  defp url(opts) do
    cond do
      to = opts[:to] ->
        case to do
          "//" <> _ -> raise_invalid_url(to)
          "/" <> _  -> to
          _         -> raise_invalid_url(to)
        end
      external = opts[:external] ->
        external
      true ->
        raise ArgumentError, "expected :to or :external option in redirect/2"
    end
  end
  defp raise_invalid_url(url) do
    raise ArgumentError, "the :to option in redirect expects a path but was #{inspect url}"
  end

  defp send_resp(conn, default_status, default_content_type, body) do
    conn
    |> ensure_resp_content_type(default_content_type)
    |> send_resp(conn.status || default_status, body)
  end

  defp ensure_resp_content_type(%{resp_headers: resp_headers} = conn, content_type) do
    if List.keyfind(resp_headers, "content-type", 0) do
      conn
    else
      content_type = content_type <> "; charset=utf-8"
      %{conn | resp_headers: [{"content-type", content_type}|resp_headers]}
    end
  end

end
