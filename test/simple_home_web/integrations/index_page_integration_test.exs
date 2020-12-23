defmodule SimpleHomeWeb.Integrations.IndexPageTest do
  use SimpleHomeWeb.IntegrationCase, async: true

  test "home page  user not logged in", %{conn: conn} do
    get(conn, Routes.page_path(conn, :index))
    |> assert_response(status: 200, path: Routes.page_path(conn, :index))
  end
end
