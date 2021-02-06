defmodule SimpleHomeWeb.Authorization do
  @moduledoc false
  import Plug.Conn
  import Phoenix.Controller
  alias SimpleHomeWeb.Router.Helpers, as: Routes
  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
