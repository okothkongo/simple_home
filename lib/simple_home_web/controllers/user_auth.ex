defmodule SimpleHomeWeb.UserAuth do
  @moduledoc false
  import Plug.Conn
  import Phoenix.Controller
  alias SimpleHomeWeb.Router.Helpers, as: Routes
  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && SimpleHome.Accounts.get_user(user_id)
    assign(conn, :current_user, user)
  end

  def log_in_user(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
    |> put_flash(:info, "Welcome back #{user.first_name}")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
