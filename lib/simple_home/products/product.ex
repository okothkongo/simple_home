defmodule SimpleHome.Products.Product do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleHome.Accounts.User

  schema "products" do
    field :category, :string
    field :description, :string
    field :images, :string
    field :name, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:images, :name, :description, :category, :user_id])
    |> validate_required([:images, :name, :description, :category, :user_id])
  end
end
