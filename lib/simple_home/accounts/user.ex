defmodule SimpleHome.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleHome.Accounts.Credential
   alias SimpleHome.Products.Product

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    has_one :credential, Credential
    has_many :products, Product
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
    |> validate_format(:last_name, ~r/(\A\D{1,30}\Z)/,
      message: "should not contain integer and at most 30 characters"
    )
    |> validate_format(:first_name, ~r/(\A\D{1,30}\Z)/,
      message: "should not contain integer and at most 30 characters"
    )
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end
end
