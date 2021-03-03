defmodule SimpleHomeWeb.CartLive.Index do
  @moduledoc false
  use SimpleHomeWeb, :live_view
  alias SimpleHome.Products

  def mount(_params, %{"cart_id" => id}, socket) do
    {:ok,
     socket
     |> cart_contents(id)
     |> set_total_price()
     |> set_cart_id(id)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply,
     socket
     |> cart_contents(socket.assigns.cart_id)
     |> set_total_price()}
  end

  defp set_cart_id(socket, id) do
    assign(socket, :cart_id, id)
  end

  defp cart_contents(socket, id) do
    assign(
      socket,
      :products,
      id
      |> Products.get_cart_content()
      |> price_per_product_count()
    )
  end

  defp calculate_total_price(socket) do
    socket.assigns.products
    |> Enum.reduce(0, fn {_product, _number, price}, acc -> price + acc end)
  end

  defp set_total_price(socket) do
    assign(socket, :total_price, calculate_total_price(socket))
  end

  defp number_of_appearance(products) do
    products
    |> Enum.group_by(fn product -> product.id end)
    |> Map.values()
    |> Enum.map(fn similar_product -> Enum.count(similar_product) end)
  end

  defp unique_products_in_cart(products) do
    products
    |> Enum.uniq()
  end

  defp product_and_appearance(products) do
    Enum.zip(unique_products_in_cart(products), number_of_appearance(products))
  end

  defp price_per_product_count(products) do
    products
    |> product_and_appearance()
    |> Enum.map(fn {product, number} ->
      {product, number, number * Decimal.to_float(product.price)}
    end)
  end

  def handle_event("delete_product", %{"value" => product_id}, socket) do
    Products.remove_product_from_cart(product_id, socket.assigns.cart_id)
    {:noreply, push_patch(socket, to: Routes.cart_index_path(socket, :index))}
  end
end
