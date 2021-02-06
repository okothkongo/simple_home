defmodule SimpleHomeWeb.ProductLiveTest do
  use SimpleHomeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  import SimpleHome.Factory

  @invalid_attrs %{category: nil, description: nil, images: nil, name: nil}

  test "lists all products", %{conn: conn} do
    product = insert!(:product)
    {:ok, _index_live, html} = live(conn, Routes.product_index_path(conn, :index))

    assert html =~ "Listing Products"
    assert html =~ product.category
  end

  describe "create product" do
    test "saves new product", %{conn: conn} do
      conn = conn_with_user_in_session(conn)
      {:ok, new_live, _html} = live(conn, Routes.product_new_path(conn, :new))

      assert new_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, conn} =
        new_live
        |> form("#product-form",
          product: %{
            category: "electronics",
            description: "some description",
            images: "some images",
            name: "some name"
          }
        )
        |> render_submit()
        |> follow_redirect(conn, Routes.product_index_path(conn, :index))

      assert html_response(conn, 200) =~ "electronics"
    end

    test "thhhhhh", %{conn: conn} do
      assert {:error, {_, %{to: to}}} = live(conn, Routes.product_new_path(conn, :new))

      assert to == Routes.page_path(conn, :index)
    end
  end

  defp conn_with_user_in_session(conn) do
    user = insert!(:user)
    Plug.Test.init_test_session(conn, user_id: user.id)
  end
end
