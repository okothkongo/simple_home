defmodule SimpleHome.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  schema "credentials" do
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    belongs_to :user, SimpleHome.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [
      :email,
      :password,
      :user_id,
      :hashed_password
    ])
    |> hash_password()
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: _password}} ->
        put_change(
          changeset,
          :hashed_password,
          "ppppp"
        )

      _ ->
        changeset
    end
  end
end
