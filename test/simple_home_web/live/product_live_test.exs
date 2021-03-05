defmodule SimpleHomeWeb.ProductLiveTest do
  use SimpleHomeWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  import SimpleHome.Factory

  describe "create product" do
    test "successfuly save product", %{conn: conn} do
      conn
      |> conn_with_user_in_session()
      |> live(Routes.product_new_path(conn, :new))
      |> elem(1)
      |> form("#product-form",
        product: %{
          price: "2.20",
          description: "some description",
          images: "some images",
          name: "some name"
        }
      )
      |> render_submit()
      |> follow_redirect(conn, Routes.page_index_path(conn, :index))
      |> elem(1)
      |> html_response(200) =~
        "2.2"
        |> assert()
    end

    test "invalid attrs", %{conn: conn} do
      conn
      |> conn_with_user_in_session()
      |> live(Routes.product_new_path(conn, :new))
      |> elem(1)
      |> form("#product-form",
        product: %{price: nil, description: nil, images: nil, name: nil}
      )
      |> render_change() =~ "can&apos;t be blank"
    end

    test "user not in session cannot acess product creation page", %{conn: conn} do
      assert {:error, {_, %{to: to}}} = live(conn, Routes.product_new_path(conn, :new))
      assert to == Routes.page_index_path(conn, :index)
    end
  end

  defp conn_with_user_in_session(conn) do
    user = insert!(:user)
    Plug.Test.init_test_session(conn, user_id: user.id)
  end
end
