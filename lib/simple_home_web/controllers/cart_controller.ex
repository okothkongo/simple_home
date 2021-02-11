defmodule SimpleHomeWeb.CartsController do
  use SimpleHomeWeb, :controller
  alias SimpleHome.Products
  alias SimpleHomeWeb.Cart

  def create(conn, %{"product_id" => product_id}) do
    case maybe_cart_in_session(conn) do
      nil ->
        case Products.create_cart() do
          {:ok, cart} ->
            attrs = %{cart_id: cart.id, product_id: product_id}

            conn =
              conn
              |> Cart.put_cart_session(cart)

            case Products.create_line_item(attrs) do
              {:ok, _line_item} ->
                products = Products.get_cart_content(cart.id)

                conn
                |> assign(:products, products)
                |> render("index.html")

              {:error, _} ->
                conn
                |> put_flash(:error, "product unable to be added to the cart try again")
                |> redirect(to: Routes.product_index_path(conn, :index))
            end

          {:error, _} ->
            conn |> redirect(to: Routes.product_index_path(conn, :index))
        end

      cart ->
        attrs = %{cart_id: cart.id, product_id: product_id}

        case Products.create_line_item(attrs) do
          {:ok, _line_item} ->
            products = Products.get_cart_content(cart.id)

            conn
            |> assign(:products, products)
            |> render("index.html")

          {:error, _} ->
            conn
            |> put_flash(:error, "product unable to be added to the cart try again")
            |> redirect(to: Routes.product_index_path(conn, :index))
        end
    end
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end

  defp maybe_cart_in_session(conn) do
    conn.assigns.current_cart
  end
end
