defmodule Oauthenator.Repo.Migrations.AddOauthClient do
  use Ecto.Migration

  def change do
    create table(:oauth_clients) do
      add :random_id, :string
      add :secret, :string
      add :allowed_grant_types, :string
      add :redirect_url, :string

      timestamps
    end
  end
end
