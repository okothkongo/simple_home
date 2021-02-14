defmodule SimpleHomeWeb.ProductLive.Index do
  @moduledoc false
  use SimpleHomeWeb, :live_view

  alias SimpleHome.Products

  def mount(_params, %{"cart_id" => cart_id}, socket) do
    {:ok, assign(socket, latest_products: latest_products(), cart_id: cart_id)}
  end

  def handle_event("Add to Cart", %{"value" => product_id}, socket) do
    socket
    |> product_attrs(product_id)
    |> Products.create_line_item()

    {:noreply,
     socket
     |> redirect(to: Routes.cart_index_path(socket, :index))}
  end

  defp latest_products do
    Products.latest_products()
  end

  defp product_attrs(socket, product_id) do
    %{cart_id: socket.assigns.cart_id, product_id: product_id}
  end
end
