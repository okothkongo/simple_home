defmodule SimpleHomeWeb.ProductLive.Index do
  @moduledoc false
  use SimpleHomeWeb, :live_view

  alias SimpleHome.Products

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :products, list_products())}
  end

  defp list_products do
    Products.list_products()
  end
end
