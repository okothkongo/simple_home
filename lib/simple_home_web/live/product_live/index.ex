defmodule SimpleHomeWeb.ProductLive.Index do
  @moduledoc false
  use SimpleHomeWeb, :live_view

  alias SimpleHome.Products

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :products, latest_products())}
  end

  defp latest_products do
    Products.latest_products()
  end
end
