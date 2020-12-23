defmodule SimpleHomeWeb.UserSessionController do
  use SimpleHomeWeb, :controller

  alias SimpleHome.Accounts
  alias SimpleHomeWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    case Accounts.authenticate_by_email_and_password(email, password) do
      {:ok, user} ->
        conn
        |> UserAuth.log_in_user(user)

      {:error, _} ->
        render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    UserAuth.log_out_user(conn)
  end
end
