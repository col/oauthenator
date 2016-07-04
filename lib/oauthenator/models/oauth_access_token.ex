defmodule Oauthenator.OauthAccessToken do
  use Ecto.Schema
  use Timex.Ecto.Timestamps
  import Ecto.Query
  import Ecto.Changeset
  alias Oauthenator.{OauthAccessToken, Repo}

  schema "oauth_access_tokens" do
    field :token, :string
    field :expires_at, Timex.Ecto.DateTime

    belongs_to :user, Oauthenator.User
    belongs_to :oauth_client, Oauthenator.OauthClient
  end

  @required_fields ~w(token expires_at oauth_client_id)
  @optional_fields ~w(user_id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> assoc_constraint(:user)
    |> assoc_constraint(:oauth_client)
  end

  def get_access_token(token, expires_at) do
    OauthAccessToken
      |> where(token: ^token)
      |> where([t], t.expires_at > ^expires_at)
      |> Repo.one
  end
end
