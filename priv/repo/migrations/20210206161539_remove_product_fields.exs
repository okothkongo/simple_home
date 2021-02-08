defmodule SimpleHome.Repo.Migrations.RemoveProductFields do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :price, :decimal, null: false, precision: 8, scale: 2
      remove :category
    end

    create constraint("products", :price_must_be_positive, check: "price >= 1 or price < 1000000")
  end
end
