defmodule SimpleHomeWeb.CartLiveTest do
  use SimpleHomeWeb.ConnCase
  import Phoenix.LiveViewTest
  import SimpleHome.Factory

  test "add product to cart succefully", %{conn: conn} do
    insert!(:product)
    {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

    index_live
    |> element("button", "Add to Cart")
    |> render_click()
    |> follow_redirect(conn)
    |> elem(1)
    |> html_response(200) =~ "Your Cart"
  end
end
