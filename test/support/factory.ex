defmodule SimpleHome.Factory do
  @moduledoc false
  alias SimpleHome.Repo
  alias SimpleHome.Accounts.{Credential, Password, User}

  def build(:user) do
    %User{first_name: "Jane", last_name: "Doe", credential: build(:credential)}
  end

  def build(:credential) do
    %Credential{
      email: "janedoe#{System.unique_integer([:positive])}@example.com",
      hashed_password: Password.hash_password("Strong@123")
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
