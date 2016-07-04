defmodule Oauthenator.Repo.Migrations.AddOauthAccessToken do
  use Ecto.Migration

  def change do
    create table(:oauth_access_tokens) do
      add :token, :string
      add :expires_at, :timestamp

      add :user_id, references(:users, on_delete: :nothing)
      add :oauth_client_id, references(:oauth_clients, on_delete: :nothing)
    end
    create index(:oauth_access_tokens, [:user_id, :oauth_client_id])
  end
end
