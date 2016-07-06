defmodule Oauthenator.OauthRefreshToken do
  use Ecto.Schema
  use Timex.Ecto.Timestamps
  import Ecto.Changeset

  schema "oauth_refresh_tokens" do
    field :token, :string
    field :expires_at, Timex.Ecto.DateTime
    field :is_delete, :boolean

    belongs_to :user, Oauthenator.User
    belongs_to :oauth_client, Oauthenator.OauthClient
  end

  @required_fields ~w(token expires_at is_delete oauth_client_id)
  @optional_fields ~w(user_id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> assoc_constraint(:user)
    |> assoc_constraint(:oauth_client)
  end
end
