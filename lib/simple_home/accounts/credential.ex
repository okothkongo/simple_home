defmodule SimpleHome.Accounts.Credential do
  @moduledoc """
  credentials schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "credentials" do
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    belongs_to :user, SimpleHome.Accounts.User
    timestamps()
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [
      :email,
      :password,
      :user_id,
      :hashed_password
    ])
    |> validate_email()
    |> validate_password()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, email_regex())
    |> unique_constraint(:email)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_confirmation(:password)
    |> validate_length(:password, min: 6, max: 80)
    |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    |> validate_format(:password, ~r/(?=.*[[:^alnum:]])/, message: "punctuation character")
    |> validate_format(:password, ~r/(?=.*\d)/, message: "at least one digit")
    |> hash_password()
  end

  defp email_regex do
    ~r/\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
  end

  #  def password_regex do
  #     ~r/\A (?=.{8,}) (?=.*\d) (?=.*[a-z]) (?=.*[A-Z])(?=.*[[:^alnum:]])/x
  #   end
  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(
          changeset,
          :hashed_password,
          SimpleHome.Accounts.Password.hash_password(password)
        )

      _ ->
        changeset
    end
  end
end
