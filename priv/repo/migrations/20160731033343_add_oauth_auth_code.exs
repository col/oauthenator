defmodule Oauthenator.Repo.Migrations.AddOauthAuthCode do
  use Ecto.Migration

  def change do
    create table(:oauth_auth_code) do
      add :code, :string
      add :expires_at, :timestamp

      add :user_id, references(:users, on_delete: :nothing)
      add :oauth_client_id, references(:oauth_clients, on_delete: :nothing)
    end
    create index(:oauth_auth_code, [:user_id, :oauth_client_id])
  end
end
