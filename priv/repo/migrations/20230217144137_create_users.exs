defmodule SimpleHome.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :phone_number, :string, null: false
      add :verified, :boolean, default: false, null: false

      timestamps()
    end
  end
end
