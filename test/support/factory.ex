defmodule SimpleHome.Factory do
  @moduledoc false
  alias SimpleHome.Repo
  alias SimpleHome.Accounts.{Credential, Password, User}
  alias SimpleHome.Products.Product

  def build(:user) do
    %User{first_name: "Jane", last_name: "Doe", credential: build(:credential)}
  end

  def build(:credential) do
    %Credential{
      email: "janedoe#{System.unique_integer([:positive])}@example.com",
      hashed_password: Password.hash_password("Strong@123")
    }
  end

  def build(:product) do
    user = insert!(:user)

    %Product{
      category: "some category",
      description: "some description",
      images: "some images",
      name: "some name",
      user_id: user.id
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
