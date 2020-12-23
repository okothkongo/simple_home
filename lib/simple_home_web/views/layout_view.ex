defmodule SimpleHomeWeb.LayoutView do
  use SimpleHomeWeb, :view

  def current_user(conn) do
    conn.assigns.current_user
  end

  def first_name(conn) do
    current_user = current_user(conn)
    current_user.first_name
  end
end
