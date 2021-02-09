defmodule SimpleHome.Products.Cart do
  @moduledoc false
  use Ecto.Schema
  # import Ecto.Changeset
  alias SimpleHome.Products.LineItem

  schema "carts" do
    has_many :line_items, LineItem
    timestamps()
  end
end
