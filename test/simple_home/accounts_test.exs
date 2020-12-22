defmodule SimpleHome.AccountsTest do
  use SimpleHome.DataCase
  alias SimpleHome.Accounts

  describe "users" do
    alias SimpleHome.Accounts.User

    @valid_attrs %{
      first_name: "some first_name",
      last_name: "some last_name",
      credential: %{
        email: "janedoe@example.com",
        password: "Some@password1",
        password_confirmation: "Some@password1"
      }
    }

    @invalid_attrs %{}
    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "create_user/1 with valid attributes creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
    end

    test "create_user/1 with invalid attributes returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "user with existing email cannot be created" do
      Accounts.create_user(@valid_attrs)
      assert {:error, changeset} = Accounts.create_user(@valid_attrs)

      assert %{credential: %{email: ["has already been taken"]}} ==
               errors_on(changeset)
    end
  end

  test "invalid passwords" do
    invalid_passwords = ~w(Some@password Somepassword1 Ps!w1 some@password1 SOME@PASSWORD1)

    for invalid_password <- invalid_passwords do
      assert {:error, changeset} = Accounts.create_user(invalid_password_attrs(invalid_password))

      refute changeset.valid?
    end
  end

  test "invalid emails" do
    invalid_emails = ~w(janeexample.com jane@example jane@example.)

    for email <- invalid_emails do
      assert {:error, changeset} = Accounts.create_user(invalid_email_attrs(email))

      refute changeset.valid?
    end
  end

  defp invalid_password_attrs(password) do
    %{
      first_name: "some first_name",
      last_name: "some last_name",
      credential: %{
        email: "janedoe@example.com",
        password: password,
        password_confirmation: password
      }
    }
  end

  defp invalid_email_attrs(email) do
    %{
      first_name: "some first_name",
      last_name: "some last_name",
      credential: %{
        email: email,
        password: "Some@password1",
        password_confirmation: "Some@password1"
      }
    }
  end
end
