defmodule SimpleHomeWeb.SharedView do
  use SimpleHomeWeb, :view
  alias SimpleHome.Products

  def current_user(conn) do
    conn.assigns.current_user
  end

  def first_name(conn) do
    current_user = current_user(conn)
    current_user.first_name
  end

  def number_of_product_in_cart(conn) do
    conn.assigns.current_cart.id
    |> Products.get_cart_content()
    |> Enum.count()
  end
end
