defmodule SimpleHome.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleHome.Accounts.Credential

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :phone_number, :string
    field :verified, :boolean, default: false
    has_one :credential, Credential

    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:first_name, :last_name, :phone_number, :verified])
    |> validate_required([:first_name, :last_name, :phone_number, :verified])
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :phone_number, :verified])
    |> validate_required([:first_name, :last_name, :phone_number, :verified])
  end
end
