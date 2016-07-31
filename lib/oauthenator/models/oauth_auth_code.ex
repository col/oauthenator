defmodule Oauthenator.OauthAuthCode do
  use Ecto.Schema
  use Timex.Ecto.Timestamps
  import Ecto.Query
  import Ecto.Changeset
  alias Oauthenator.{OauthAuthCode, Repo, User, OauthClient}

  schema "oauth_auth_code" do
    field :code, :string
    field :expires_at, Timex.Ecto.DateTime

    belongs_to :user, User
    belongs_to :oauth_client, OauthClient
  end

  @required_fields ~w(code expires_at oauth_client_id)
  @optional_fields ~w(user_id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> assoc_constraint(:user)
    |> assoc_constraint(:oauth_client)
  end

  def get_auth_code(code, expires_at) do
    OauthAuthCode
      |> where(code: ^code)
      |> where([t], t.expires_at > ^expires_at)
      |> Repo.one
  end

  def get_existing_auth_code(user_id, client_id) do
    OauthAuthCode
      |> where(user_id: ^user_id)
      |> where(oauth_client_id: ^client_id)
      |> Repo.one
  end
end
