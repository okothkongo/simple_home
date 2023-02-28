defmodule SimpleHomeWeb.UserVisitsHomepageTest do
  use SimpleHomeWeb.FeatureCase, async: true

  test "user can visit homepage", %{session: session} do
    session
    |> visit("/")
    |> assert_text("Welcome to Phoenix!")
  end
end
