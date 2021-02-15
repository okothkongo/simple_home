defmodule SimpleHomeWeb.SearchComponent do
  @moduledoc false

  use Phoenix.LiveComponent
  alias SimpleHome.Products

  def render(assigns) do
    ~L"""
    <div class="columns">
      <div class="column is-four-fifths">
        <div class="field">
          <div class="control">
            <input class="input" type="text" placeholder="search product">
          </div>
        </div>
      </div>
      <div class="column">
        <%= @no_of_products %>
        <p><i class="fas fa-cart-plus"></i></p>
      </div>
    </div>
    """
  end

  def update(assigns, socket) do
    {:ok, assign(socket, :no_of_products, number_of_product_in_cart(assigns))}
  end

  defp number_of_product_in_cart(assigns) do
    assigns.cart_id
    |> Products.get_cart_content()
    |> Enum.count()
  end
end
