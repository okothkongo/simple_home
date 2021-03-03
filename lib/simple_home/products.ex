defmodule SimpleHome.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias SimpleHome.Repo

  alias SimpleHome.Products.Cart
  alias SimpleHome.Products.LineItem
  alias SimpleHome.Products.Product
  alias SimpleHome.Products.Query, as: ProductQuery

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  def latest_products do
    ProductQuery.latest_products()
    |> Repo.all()
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  def create_cart do
    %Cart{}
    |> Repo.insert()
  end

  def get_cart(id), do: Repo.get(Cart, id)

  def create_line_item(attrs) do
    %LineItem{}
    |> LineItem.changeset(attrs)
    |> Repo.insert()
  end

  def get_cart_content(id) do
    ProductQuery.get_cart_content(id)
    |> Repo.all()
  end

  def remove_product_from_cart(product_id, cart_id) do
    ProductQuery.remove_product_from_cart(product_id, cart_id)
    |> Repo.delete_all()
  end
end
