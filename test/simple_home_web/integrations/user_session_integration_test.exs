defmodule SimpleHomeWeb.Integrations.UserSessionTest do
  use SimpleHomeWeb.IntegrationCase

  setup do
    user = insert!(:user)
    [user: user]
  end

  describe "create new session" do
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

  test "user can successfully log out", %{conn: conn, user: user} do
    get(conn, Routes.user_session_path(conn, :new))
    |> follow_form(%{user: %{email: user.credential.email, password: "Strong@123"}})
    |> click_link("Log Out", method: :delete)
    |> follow_redirect()
    |> assert_response(
      html: "Logged out successfully.",
      path: Routes.page_path(conn, :index)
    )
    |> refute_response(html: "#{user.first_name}")
  end
end
