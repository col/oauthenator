defmodule Oauthenator.Repo.Migrations.AddOauthRefreshToken do
  use Ecto.Migration

  def change do
    create table(:oauth_refresh_tokens) do
      add :token, :string
      add :expires_at, :timestamp
      add :is_delete, :boolean

      add :user_id, references(:users, on_delete: :nothing)
      add :oauth_client_id, references(:oauth_clients, on_delete: :nothing)
    end
    create index(:oauth_refresh_tokens, [:user_id, :oauth_client_id])
  end
end
