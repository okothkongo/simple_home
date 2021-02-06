defmodule SimpleHomeWeb.ProductLive.New do
  @moduledoc false
  use SimpleHomeWeb, :live_view
  alias SimpleHome.Products
  alias SimpleHome.Products.Product

  def mount(_params, %{"user_id" => user_id}, socket) do
    {:ok,
     socket
     |> assign(
       changeset: change_product(%Product{}),
       user_id: user_id
     )}
  end

  def handle_event("validate", %{"product" => params}, socket) do
    changeset =
      %Product{}
      |> change_product(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"product" => params}, socket) do
    params
    |> Products.create_product()
    |> case do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "product has been successfully created")
         |> redirect(to: Routes.product_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp change_product(product, attrs \\ %{}) do
    Products.change_product(product, attrs)
  end
end
