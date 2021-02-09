defmodule SimpleHome.Products.LineItem do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleHome.Products.Product
  alias SimpleHome.Products.Cart

  schema "line_items" do
    belongs_to :product, Product
    belongs_to :cart, Cart
    timestamps()
  end

  def changeset(line_item, attrs) do
    line_item
    |> cast(attrs, [:product_id, :cart_id])
  end
end
