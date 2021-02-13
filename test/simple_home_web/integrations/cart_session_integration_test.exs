defmodule SimpleHomeWeb.Integrations.CartSessionTest do
  use SimpleHomeWeb.IntegrationCase

  test "yyy", %{conn: conn} do
    insert!(:product)

    conn =
      get(conn, Routes.product_index_path(conn, :index))
      |> click_link("Add to Cart")

    conn |> IO.inspect()
  end
end
