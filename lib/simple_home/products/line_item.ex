defmodule SimpleHome.Products.LineItem do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleHome.Products.{Cart, Product}

  schema "line_items" do
    belongs_to :product, Product
    belongs_to :cart, Cart
    timestamps()
  end

  def changeset(line_item, attrs \\ %{}) do
    line_item
    |> cast(attrs, [:product_id, :cart_id])
    |> validate_required([:product_id, :cart_id])
  end
end
