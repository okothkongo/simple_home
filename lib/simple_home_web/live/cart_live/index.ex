defmodule SimpleHomeWeb.CartLive.Index do
  @moduledoc false
  use SimpleHomeWeb, :live_view
  alias SimpleHome.Products

  def mount(_params, %{"cart_id" => cart_id}, socket) do
    {:ok, socket |> add_products(cart_id)}
  end

  defp add_products(socket, cart_id) do
    assign(socket, :products, get_cart_content(cart_id))
  end

  defp get_cart_content(cart_id) do
    Products.get_cart_content(cart_id)
  end
end
