defmodule SimpleHome.Repo.Migrations.CreateLineItem do
  use Ecto.Migration

  def change do
    create table(:line_items) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :cart_id, references(:carts, on_delete: :delete_all), null: false
      timestamps()
    end
  end
end
