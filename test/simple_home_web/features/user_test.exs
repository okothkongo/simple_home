defmodule SimpleHomeWeb.UserLiveTest do
  use SimpleHomeWeb.FeatureCase
  alias SimpleHome.Accounts

  import SimpleHome.Factory

  # setup do
  #   %{user: insert!(:user)}
  # end

  describe "Index" do
    feature "create user", %{session: session} do
      session
      |> visit("/users/new")
      |> fill_in(text_field("First name"), with: "John")
      |> fill_in(text_field("Last name"), with: "Doe")
      |> fill_in(text_field("Phone number"), with: "01")
      |> fill_in(text_field("Email"), with: "Jane")
      |> fill_in(text_field("Password"), with: "Jane")
      |> click(button("Save"))
      |> visit("/users")
      |> assert_text("John")

      assert [user] = Accounts.list_users()
      assert user.first_name == "John"
    end

    feature "create user invalid", %{session: session} do
      session
      |> visit("/users/new")
      |> fill_in(text_field("First name"), with: "")
      |> click(button("Save"))
      |> assert_text("can't be blank")

      assert [] = Accounts.list_users()
    end

    feature "lists all users", %{session: session} do
      user = insert!(:user)
      session = visit(session, "/users")
      assert_text(session, "Listing Users")
      assert_text(session, user.first_name)
    end

    feature "update user", %{session: session} do
      user = insert!(:user)

      session =
        session
        |> visit("/users/#{user.id}/edit")
        |> fill_in(text_field("First name"), with: "Jake")
        |> click(button("Save"))

      session
      |> visit("/users")
      |> assert_text("Jake")

      session
      |> visit("/users")
      |> refute_has(Query.text(user.first_name))

      assert [fetched_user] = Accounts.list_users()
      assert fetched_user.first_name == "Jake"
      assert fetched_user.last_name == user.last_name
    end

    feature "update user invalid", %{session: session} do
      user = insert!(:user)

      session
      |> visit("/users/new")
      |> fill_in(text_field("First name"), with: "")
      |> click(button("Save"))
      |> assert_text("can't be blank")

      assert [fetched_user] = Accounts.list_users()
      assert fetched_user.first_name == user.first_name
    end

    feature "show", %{session: session} do
      user = insert!(:user)

      session =
        session
        |> visit("/users/#{user.id}")

      session
      |> assert_text(user.first_name)

      session
      |> assert_text("Show User")
    end
  end
end
