defmodule SimpleHome.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :images, :string
      add :name, :string
      add :description, :text
      add :category, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:products, [:user_id])
  end
end
