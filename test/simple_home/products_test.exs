defmodule SimpleHome.ProductsTest do
  use SimpleHome.DataCase

  alias SimpleHome.Products

  describe "products" do
    alias SimpleHome.Products.Product

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

      assert product.price |> Decimal.to_float() == 2.25
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
                 name: "some updated name"
               })

      assert product.description == "some updated description"
      assert product.images == "some updated images"
      assert product.name == "some updated name"
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
end
