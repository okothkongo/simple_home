defmodule SimpleHome.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:credentials) do
      add :email, :string
      add :hashed_password, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end

    create unique_index(:credentials, [:email])
  end
end
