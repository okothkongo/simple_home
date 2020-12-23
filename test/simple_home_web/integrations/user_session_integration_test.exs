defmodule SimpleHomeWeb.Integrations.UserSessionTest do
  use SimpleHomeWeb.IntegrationCase
  alias SimpleHome.Accounts

  @valid_attrs %{
    first_name: "some first_name",
    last_name: "some last_name",
    credential: %{
      email: "janedoe@example.com",
      password: "Some@password1",
      password_confirmation: "Some@password1"
    }
  }

  describe "create new session" do
    test "user with right credential can login", %{conn: conn} do
      {:ok, user} = Accounts.create_user(@valid_attrs)

      get(conn, Routes.user_session_path(conn, :new))
      |> follow_form(%{user: %{email: user.credential.email, password: "Some@password1"}})
      |> follow_redirect()
      |> assert_response(
        html: "Welcome back #{user.first_name}",
        path: Routes.page_path(conn, :index)
      )
    end

    test "user with wrong password cannot login", %{conn: conn} do
      {:ok, user} = Accounts.create_user(@valid_attrs)

      get(conn, Routes.user_session_path(conn, :new))
      |> follow_form(%{user: %{email: user.credential.email, password: "invalid"}})
      |> follow_redirect()
      |> assert_response(
        html: "Invalid email or password",
        path: Routes.user_session_path(conn, :create)
      )
    end

    test "user with wrong email cannot login", %{conn: conn} do
      {:ok, _user} = Accounts.create_user(@valid_attrs)

      get(conn, Routes.user_session_path(conn, :new))
      |> follow_form(%{user: %{email: "invalid@example.com", password: "Some@password1"}})
      |> follow_redirect()
      |> assert_response(
        html: "Invalid email or password",
        path: Routes.user_session_path(conn, :create)
      )
    end
  end
end
