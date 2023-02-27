defmodule SimpleHome.Factory do
  @moduledoc false
  alias SimpleHome.Repo
  alias SimpleHome.Accounts.{Credential, User}

  def build(:user) do
    %User{
      first_name: "Jane",
      last_name: "Doe",
      phone_number: "pppp#{System.unique_integer([:positive])}",
      credential: build(:credential)
    }
  end

  def build(:credential) do
    password = Bcrypt.add_hash("Strongp1234@.")

    %Credential{
      email: "janedoe#{System.unique_integer([:positive])}@example.com",
      hashed_password: password.password_hash
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
