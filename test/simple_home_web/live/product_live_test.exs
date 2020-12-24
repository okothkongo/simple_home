defmodule SimpleHomeWeb.ProductLiveTest do
  use SimpleHomeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  import SimpleHome.Factory

  @update_attrs %{
    category: "some updated category",
    description: "some updated description",
    images: "some updated images",
    name: "some updated name"
  }
  @invalid_attrs %{category: nil, description: nil, images: nil, name: nil}

  describe "Index" do
    setup do
      product = insert!(:product)
      [product: product]
    end

    test "lists all products", %{conn: conn, product: product} do
      {:ok, _index_live, html} = live(conn, Routes.product_index_path(conn, :index))

      assert html =~ "Listing Products"
      assert html =~ product.category
    end

    test "saves new product", %{conn: conn} do
      user = insert!(:user)
      {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

      assert index_live |> element("a", "New Product") |> render_click() =~
               "New Product"

      assert_patch(index_live, Routes.product_index_path(conn, :new))

      assert index_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#product-form",
          product: %{
            category: "electronics",
            description: "some description",
            images: "some images",
            name: "some name",
            user_id: user.id
          }
        )
        |> render_submit()
        |> follow_redirect(conn, Routes.product_index_path(conn, :index))

      assert html =~ "electronics"
    end

    test "updates product in listing", %{conn: conn, product: product} do
      {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

      assert index_live |> element("#product-#{product.id} a", "Edit") |> render_click() =~
               "Edit Product"

      assert_patch(index_live, Routes.product_index_path(conn, :edit, product))

      assert index_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#product-form", product: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_index_path(conn, :index))

      assert html =~ "some updated category"
    end

    test "deletes product in listing", %{conn: conn, product: product} do
      {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

      assert index_live |> element("#product-#{product.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#product-#{product.id}")
    end
  end

  describe "Show" do
    setup do
      product = insert!(:product)
      [product: product]
    end

    test "displays product", %{conn: conn, product: product} do
      {:ok, _show_live, html} = live(conn, Routes.product_show_path(conn, :show, product))

      assert html =~ "Show Product"
      assert html =~ product.category
    end

    test "updates product within modal", %{conn: conn, product: product} do
      {:ok, show_live, _html} = live(conn, Routes.product_show_path(conn, :show, product))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Product"

      assert_patch(show_live, Routes.product_show_path(conn, :edit, product))

      assert show_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#product-form", product: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_show_path(conn, :show, product))

      assert html =~ "some updated category"
    end
  end
end
