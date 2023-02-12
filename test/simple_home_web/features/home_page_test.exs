defmodule SimpleHomeWeb.UserVisitsHomepageTest do
  use SimpleHomeWeb.FeatureCase, async: true

  test "user can visit homepage", %{session: session} do
    session =
      session
      |> visit("/")
      |> text()

    assert session =~ "Welcome to Phoenix!"
  end
end
