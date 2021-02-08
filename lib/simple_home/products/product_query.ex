defmodule SimpleHome.Products.Query do
  @moduledoc false
  import Ecto.Query
  alias SimpleHome.Products.Product

  def latest_products do
    from(p in Product, order_by: [desc: :inserted_at], limit: 12)
  end
end
