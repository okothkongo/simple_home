defmodule SimpleHome.Repo.Migrations.CreateCredential do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    alter table(:users) do
      remove :email
      remove :password
    end

    create table(:credentials) do
      add :email, :citext
      add :hashed_password, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end

    create unique_index(:credentials, [:email])
  end
end
