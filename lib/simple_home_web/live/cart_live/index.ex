defmodule SimpleHomeWeb.CartLive.Index do
  @moduledoc false
  use SimpleHomeWeb, :live_view
  alias SimpleHome.Products

  def mount(_params, %{"cart_id" => id}, socket) do
    {:ok, assign(socket, :products, cart_contents(id))}
  end

  defp cart_contents(id) do
    Products.get_cart_content(id)
    |> IO.inspect()
  end
end
