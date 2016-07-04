defmodule Oauthenator.Repo.Migrations.AddUserAssociations do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :oauth_access_token_id, references(:oauth_access_tokens, on_delete: :delete_all)
      add :oauth_refresh_token_id, references(:oauth_refresh_tokens, on_delete: :delete_all)
    end
    create index(:users, [:oauth_access_token_id])
    create index(:users, [:oauth_refresh_token_id])
  end
end
