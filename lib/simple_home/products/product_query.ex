defmodule SimpleHome.Products.Query do
  @moduledoc false
  import Ecto.Query
  alias SimpleHome.Products.{Cart, LineItem, Product}

  def latest_products do
    from(p in Product, order_by: [desc: :inserted_at], limit: 12)
  end

  def get_cart_content(id) do
    from l in LineItem,
      join: c in Cart,
      on: c.id == l.cart_id,
      join: p in Product,
      on: p.id == l.product_id,
      where: c.id == ^id,
      select: %{images: p.images, price: p.price, name: p.name, id: p.id}
  end
end
