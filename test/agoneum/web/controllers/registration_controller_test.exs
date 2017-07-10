defmodule Agoneum.Web.RegistrationControllerTest do
  use Agoneum.Web.ConnCase

  @create_attrs %{email: "some email", name: "some name", password: "some password"}
  @invalid_attrs %{email: nil, name: nil, password: nil}

  test "creates user and redirects to the main page", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @create_attrs
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "does not create user and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 422) =~ "Sign Up"
  end
end
