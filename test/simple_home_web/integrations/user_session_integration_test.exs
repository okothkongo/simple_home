defmodule SimpleHomeWeb.Integrations.UserSessionTest do
  use SimpleHomeWeb.IntegrationCase

  describe "create new session" do
    setup do
      user = insert!(:user)
      [user: user]
    end

    test "user with right credential can login", %{conn: conn, user: user} do
      get(conn, Routes.user_session_path(conn, :new))
      |> follow_form(%{user: %{email: user.credential.email, password: "Strong@123"}})
      |> follow_redirect()
      |> assert_response(
        html: "Welcome back #{user.first_name}",
        path: Routes.page_path(conn, :index)
      )
    end

    test "user with wrong password cannot login", %{conn: conn, user: user} do
      get(conn, Routes.user_session_path(conn, :new))
      |> follow_form(%{user: %{email: user.credential.email, password: "invalid"}})
      |> follow_redirect()
      |> assert_response(
        html: "Invalid email or password",
        path: Routes.user_session_path(conn, :create)
      )
    end

    test "user with wrong email cannot login", %{conn: conn} do
      get(conn, Routes.user_session_path(conn, :new))
      |> follow_form(%{user: %{email: "invalid@example.com", password: "Strong@123"}})
      |> follow_redirect()
      |> assert_response(
        html: "Invalid email or password",
        path: Routes.user_session_path(conn, :create)
      )
    end
  end
end
