defmodule SimpleHomeWeb.CartsController do
  use SimpleHomeWeb, :controller
  alias SimpleHome.Products

  def create(conn, %{"product_id" => product_id}) do
    attrs = %{cart_id: cart_id(conn), product_id: product_id}

    case Products.create_line_item(attrs) do
      {:ok, _line_item} ->
        products = Products.get_cart_content(cart_id(conn))

        conn
        |> assign(:products, products)
        |> render("index.html")

      {:error, _} ->
        conn
        |> put_flash(:error, "product unable to be added to the cart try again")
        |> redirect(to: Routes.product_index_path(conn, :index))
    end
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end

  defp cart_id(conn) do
    conn.assigns.current_cart.id
  end
end
