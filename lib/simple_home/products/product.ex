defmodule SimpleHome.Products.Product do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleHome.Accounts.User

  schema "products" do
    field :price, :decimal
    field :description, :string
    field :images, :string
    field :name, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:images, :name, :description, :price, :user_id])
    |> validate_required([:images, :name, :description, :price, :user_id])
    |> check_price_validity()
    |> check_constraint(:price,
      name: :price_must_be_positive,
      message: "must be greater 0 and less than 1000000"
    )
  end

  defp check_price_validity(changeset) do
    validate_change(changeset, :price, fn :price, price ->
      if Regex.match?(~r/\d+(\.\d{1,2})?/, "#{price}") do
        []
      else
        [price: "invalid value"]
      end
    end)
  end
end
