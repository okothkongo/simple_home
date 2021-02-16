defmodule SimpleHomeWeb.PageLiveTest do
  use SimpleHomeWeb.ConnCase
  import Phoenix.LiveViewTest
  import SimpleHome.Factory

  test "lists latest products ", %{conn: conn} do
    product = insert!(:product)
    {:ok, _index_live, html} = live(conn, Routes.page_index_path(conn, :index))

    assert html =~ "Latest Products"
    assert html =~ product.name
  end
end
