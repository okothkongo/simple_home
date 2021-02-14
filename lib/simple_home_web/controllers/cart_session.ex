defmodule SimpleHomeWeb.CartSession do
  @moduledoc false
  import Plug.Conn
  alias SimpleHome.Products
  #   alias SimpleHomeWeb.Router.Helpers, as: Routes
  def init(opts), do: opts

  def call(conn, _opts) do
    cart_id = get_session(conn, :cart_id)
    cart = cart_id && Products.get_cart(cart_id)
    put_cart_session(conn, cart)
  end

  defp put_cart_session(conn, nil) do
    {:ok, cart} = Products.create_cart()

    conn
    |> assign(:current_cart, cart)
    |> put_session(:cart_id, cart.id)
    |> configure_session(renew: true)
  end

  defp put_cart_session(conn, cart) do
    conn
    |> assign(:current_cart, cart)
    |> put_session(:cart_id, cart.id)
    |> configure_session(renew: true)
  end
end
