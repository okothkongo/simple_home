defmodule SimpleHome.AccountsTest do
  use SimpleHome.DataCase
  alias SimpleHome.Accounts
  alias SimpleHome.Accounts.{Password, User}

  @valid_attrs %{
    first_name: "some first_name",
    last_name: "some last_name",
    credential: %{
      email: "janedoe@example.com",
      password: "Some@password1",
      password_confirmation: "Some@password1"
    }
  }

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Accounts.create_user()

    user
  end

  describe "create_user/1" do
    test "with valid attributes creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
    end

    test "with invalid attributes returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{})
    end

    test "does not create user with existing email" do
      Accounts.create_user(@valid_attrs)
      assert {:error, changeset} = Accounts.create_user(@valid_attrs)

      assert %{credential: %{email: ["has already been taken"]}} ==
               errors_on(changeset)
    end

    test "does not create user with invalid password" do
      invalid_passwords = ~w(Some@password Somepassword1 Ps!w1 some@password1 SOME@PASSWORD1)

      for invalid_password <- invalid_passwords do
        assert {:error, changeset} =
                 Accounts.create_user(invalid_password_attrs(invalid_password))

        refute changeset.valid?
      end
    end

    test "does not create user with invalid email" do
      invalid_emails = ~w(janeexample.com jane@example jane@example.)

      for email <- invalid_emails do
        assert {:error, changeset} = Accounts.create_user(invalid_email_attrs(email))

        refute changeset.valid?
      end
    end
  end

  describe "get_user/1" do
    test "return single  existing user" do
      {:ok, %User{id: id}} = Accounts.create_user(@valid_attrs)
      user = Accounts.get_user(id)
      assert user.first_name == "some first_name"
    end

    test "returns nil when no user exists" do
      assert Accounts.get_user(1) == nil
    end
  end

  describe "password" do
    test "password is hashed" do
      hashed_password = Password.hash_password("Some@password1!")
      assert Bcrypt.verify_pass("Some@password1!", hashed_password)
    end

    test "valid password can be retrieved" do
      {:ok, user} = Accounts.create_user(@valid_attrs)
      assert Password.valid_password?(user.credential, "Some@password1")
    end

    test "invalid password fails" do
      refute Password.valid_password?("", "")
    end
  end

  describe "authenticate_by_email_and_password/2" do
    test "does not return the user if the email does not exist" do
      assert {:error, :unauthorized} ==
               Accounts.authenticate_by_email_and_password("unknown@example.com", "hello world!")
    end

    test "does not return the user if the password is not valid" do
      {:ok, user} = Accounts.create_user(@valid_attrs)

      assert {:error, :unauthorized} ==
               Accounts.authenticate_by_email_and_password(user.credential.email, "invalid")
    end

    test "returns the user if the email and password are valid" do
      {:ok, user} = Accounts.create_user(@valid_attrs)

      assert {:ok, user} =
               Accounts.authenticate_by_email_and_password(
                 user.credential.email,
                 "Some@password1"
               )

      assert user.first_name == "some first_name"
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
