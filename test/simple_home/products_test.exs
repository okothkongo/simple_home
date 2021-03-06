defmodule SimpleHome.ProductsTest do
  use SimpleHome.DataCase

  alias SimpleHome.Products
  alias SimpleHome.Products.Cart
  alias SimpleHome.Products.Product

  describe "products" do
    @invalid_attrs %{price: nil, description: nil, images: nil, name: nil}

    test "list_products/0 returns all products" do
      insert!(:product)
      assert Enum.count(Products.list_products()) == 1
    end

    test "get_product!/1 returns the product with given id" do
      product = insert!(:product)
      assert product.name == "some name"
    end

    test "create_product/1 with valid data creates a product" do
      user = insert!(:user)

      assert {:ok, %Product{} = product} =
               Products.create_product(%{
                 price: 2.25,
                 description: "some description",
                 images: "some images",
                 name: "some name",
                 user_id: user.id
               })

      assert product.price == Decimal.new("2.25")
      assert product.description == "some description"
      assert product.images == "some images"
      assert product.name == "some name"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = insert!(:product)

      assert {:ok, %Product{} = product} =
               Products.update_product(product, %{
                 description: "some updated description",
                 images: "some updated images",
                 name: "some updated name",
                 price: 4
               })

      assert product.description == "some updated description"
      assert product.images == "some updated images"
      assert product.name == "some updated name"
      assert product.price == Decimal.new(4)
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = insert!(:product)
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
    end

    test "delete_product/1 deletes the product" do
      product = insert!(:product)
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = insert!(:product)
      assert %Ecto.Changeset{} = Products.change_product(product)
    end

    test "lastest_product/0 return latest products" do
      ["cloth", "iphone"]
      |> Enum.each(fn name ->
        insert!(:product, name: name, inserted_at: ~N[2021-02-07 09:52:24])
      end)

      1..12
      |> Enum.each(fn _product ->
        insert!(:product)
      end)

      assert Enum.count(Products.latest_products()) == 12
      products = Products.latest_products() |> Enum.map(fn %Product{name: name} -> name end)
      refute Enum.member?(products, "iphone")
      refute Enum.member?(products, "cloth")
    end
  end

  test "create_cart/0 creates cart" do
    assert {:ok, %SimpleHome.Products.Cart{}} = Products.create_cart()
  end

  test "create_line_item/1 creates line item" do
    {:ok, %Cart{id: cart_id}} = Products.create_cart()
    %Product{id: product_id} = insert!(:product)

    assert {:ok, %SimpleHome.Products.LineItem{}} =
             Products.create_line_item(%{cart_id: cart_id, product_id: product_id})
  end

  test "create_line_item/1 with wrong attrs do create line item" do
    %Product{id: product_id} = insert!(:product)
    assert {:error, _changeset} = Products.create_line_item(%{product_id: product_id})
  end

  test "get_cart/1 retrieve cart with given id if it exists" do
    assert {:ok, cart} = Products.create_cart()
    assert Products.get_cart(cart.id) == cart
  end

  test "get_cart/1 retrieve returns nil if cart do not exist" do
    assert Products.get_cart(1) == nil
  end

  test "get_cart_content/1  " do
    {:ok, cart} = Products.create_cart()
    product = insert!(:product)
    Products.create_line_item(%{cart_id: cart.id, product_id: product.id})
    assert [product1] = Products.get_cart_content(cart.id)
    assert product1.name == product.name
  end

  test " remove_product_from_cart/2  " do
    {:ok, cart} = Products.create_cart()
    product = insert!(:product)
    Products.create_line_item(%{cart_id: cart.id, product_id: product.id})
    Products.remove_product_from_cart(product.id, cart.id)
  end
end
