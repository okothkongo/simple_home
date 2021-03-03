defmodule SimpleHomeWeb.CartLiveTest do
  use SimpleHomeWeb.ConnCase
  import Phoenix.LiveViewTest
  import SimpleHome.Factory

  test "cart index page", %{conn: conn} do
    conn = get(conn, Routes.page_index_path(conn, :index))
    add_to_cart(conn)
    {:ok, index_live, _html} = live(conn, Routes.cart_index_path(conn, :index))

    index_live
    |> render() =~ "2.25"
  end

  defp add_to_cart(conn) do
    product = insert!(:product)
    {:ok, index_live, _html} = live(conn, Routes.page_index_path(conn, :index))

    index_live
    |> render_click("Add to Cart", value: product.id)
  end
end
