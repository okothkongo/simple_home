defmodule SimpleHomeWeb.Cart do
  @moduledoc false
  import Plug.Conn
  alias SimpleHome.Products
  #   alias SimpleHomeWeb.Router.Helpers, as: Routes
  def init(opts), do: opts

  def call(conn, _opts) do
    cart_id = get_session(conn, :cart_id)
    cart = cart_id && Products.get_cart(cart_id)
    assign(conn, :current_cart, cart)
  end

  def put_cart_session(conn, cart) do
    conn
    |> assign(:current_cart, cart)
    |> put_session(:cart_id, cart.id)
    |> configure_session(renew: true)
  end
end
