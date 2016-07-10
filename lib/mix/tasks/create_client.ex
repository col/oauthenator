defmodule Mix.Tasks.Oauthenator.CreateClient do
  use Mix.Task
  use Timex
  alias Oauthenator.OauthClient
  alias Oauthenator.Repo

  @fields [:name, :random_id, :secret, :allowed_grant_types, :redirect_url]
  @grant_types [:password, :client_credentials, :refresh_token, :authorization_code]

  @shortdoc "Creates an oauth client."

  @moduledoc """
    The list of grant types are :
      authorization-code
      client-credentials
      refresh-token
      password

    Options :
      name
      redirect-url

    You can execute this command by:
    mix oauthenator.create_client --name Amazon --client-credentials --redirect-url http://www.example.com
  """

  def run(args) do
    start_repo
    args |> get_options |> create_client
  end

  def start_repo do
    Application.ensure_all_started(:ecto)
    Application.ensure_all_started(:postgrex)
    Repo.start_link
  end

  # converts options to map
  defp get_options(args) do
    options = OptionParser.parse(args) |> Tuple.to_list |> List.first
    Enum.reduce options, %{}, fn {key, value}, object ->
      Map.put(object, key, value)
    end
  end

  # create oauth client
  defp create_client(options) do
    changeset = OauthClient.changeset(%OauthClient{}, client_params(options))
    case Repo.insert(changeset) do
      {:ok, client} ->
        Mix.shell.info "Oauth Client Created"
        print_fields(client, @fields)
      :error ->
        Mix.shell.info "Error creating oauth client"
    end
  end

  def client_params(options) do
    allowed_grant_types = options
      |> filter_options(@grant_types)
      |> Enum.into(%{})
      |> Poison.Encoder.encode([])
      |> to_string
    %{
      name: Map.get(options, :name),
      random_id: generate_token,
      secret: generate_token,
      allowed_grant_types: allowed_grant_types,
      redirect_url: Map.get(options, :redirect_url)
    }
  end

  def generate_token do
    :crypto.strong_rand_bytes(40) |> Base.url_encode64 |> binary_part(0, 40)
  end

  def filter_options(options, include) do
    Enum.filter(options, fn({key, _}) ->
      Enum.any?(include, fn(type) -> type == key end)
    end)
  end

  defp print_fields(client, fields) do
    Enum.each(fields, fn(field) ->
      if (value = Map.get(client, field)) do
        Mix.shell.info "#{field}: #{value}"
      end
    end)
  end
end
