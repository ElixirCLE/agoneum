defmodule Agoneum.Web.RegistrationControllerTest do
  use Agoneum.Web.ConnCase

  @create_attrs %{email: "email@agoneum.com", name: "some name", password: "some password"}
  @invalid_attrs %{email: nil, name: nil, password: nil}

  test "creates user and redirects to the main page", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @create_attrs
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "does not create user and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 422) =~ "Sign Up"
  end

  test "throws an error if the email address is not formatted correctly", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: %{email: "email"}
    assert html_response(conn, 422) =~ "has invalid format"
  end

  test "throws an error if the password is too short", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: %{password: "abcd"}
    assert html_response(conn, 422) =~ "should be at least 6 character(s)"
  end

  test "throws an error if the password confirmation does not match the password", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: %{password: "abcd", password_confirmation: "efgh"}
    assert html_response(conn, 422) =~ "does not match password"
  end
end
