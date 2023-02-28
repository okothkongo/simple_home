defmodule SimpleHome.AccountsTest do
  use SimpleHome.DataCase

  alias SimpleHome.Accounts
  alias alias SimpleHome.Accounts.User
  import SimpleHome.Factory

  describe "User CRUD" do
    setup do
      %{user: insert!(:user)}
    end

    @valid_attrs %{
      first_name: "Jane",
      last_name: "Doe",
      phone_number: "071111",
      credential: %{
        email: "janedoe@example.com",
        password: "Some@password1"
      }
    }
    test "with valid attributes creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.first_name == "Jane"
      assert user.last_name == "Doe"
      assert user.verified == false
    end

    test "with invalid attributes returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{})
    end

    test "does not create user with existing email", %{user: user} do
      assert {:error, changeset} =
               Accounts.create_user(invalid_email_attrs(user.credential.email))

      assert %{credential: %{email: ["has already been taken"]}} ==
               errors_on(changeset)
    end

    test "does not create user with invalid password" do
      invalid_passwords = ~w(Some@password Somepassword1 Ps!w1 some@password1 SOME@PASSWORD1)

      for invalid_password <- invalid_passwords do
        assert {:error, changeset} =
                 Accounts.create_user(invalid_password_attrs(invalid_password))

        assert %{credential: %{password: password}} = errors_on(changeset)
        refute password == []
      end
    end

    test "does not create user with invalid email" do
      invalid_emails = ~w(janeexample.com jane@example jane@example.)

      for email <- invalid_emails do
        assert {:error, changeset} = Accounts.create_user(invalid_email_attrs(email))

        assert %{credential: %{email: ["has invalid format"]}} ==
                 errors_on(changeset)
      end
    end

    test "list_users/0 returns all users", %{user: user} do
      assert [fetched_user] = Accounts.list_users()
      assert fetched_user.first_name == user.first_name
    end

    test "get_user!/1 returns the user with given id", %{user: user} do
      assert fetched_user = Accounts.get_user!(user.id)
      assert fetched_user.first_name == user.first_name
    end

    test "update_user/2 with valid data updates the user", %{user: user} do
      update_attrs = %{
        first_name: "some updated first_name",
        last_name: "some updated last_name",
        phone_number: "some updated phone_number",
        verified: true
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.phone_number == "some updated phone_number"
      assert user.verified == true
    end

    test "update_user/2 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_user(user, %{first_name: "John", phone_number: ""})

      fetched_user = Accounts.get_user!(user.id)
      assert fetched_user.first_name == "Jane"
    end

    test "delete_user/1 deletes the user", %{user: user} do
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset", %{user: user} do
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  defp invalid_email_attrs(email) do
    %{
      first_name: "some first_name",
      last_name: "some last_name",
      phone_number: "ooo",
      credential: %{
        email: email,
        password: "Some@password1",
        password_confirmation: "Some@password1"
      }
    }
  end

  defp invalid_password_attrs(password) do
    %{
      first_name: "some first_name",
      last_name: "some last_name",
      phone_number: "000",
      credential: %{
        email: "janedoe@example.com",
        password: password,
        password_confirmation: password
      }
    }
  end
end
