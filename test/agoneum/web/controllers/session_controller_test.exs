defmodule Agoneum.Web.SessionControllerTest do
  use Agoneum.Web.ConnCase

  alias Agoneum.Account

  describe "UI login" do
    @create_attrs %{name: "some name", email: "some email", password: "some password"}
    @login_attrs %{email: "some email", password: "some password"}
    @invalid_attrs %{email: nil, password: nil}

    test "shows the login form", %{conn: conn} do
      conn = get conn, session_path(conn, :new)
      assert html_response(conn, 200) =~ "Log In"
    end

    test "logs the user in", %{conn: conn} do
      Account.create_user(@create_attrs)
      conn = post conn, session_path(conn, :create), session: @login_attrs
      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "does not log the user in when data is invalid", %{conn: conn} do
      conn = post conn, session_path(conn, :create), session: @invalid_attrs
      assert get_flash(conn, :error) == "Invalid credentials"
    end

    test "does not log the user in when data is missing", %{conn: conn} do
      conn = post conn, session_path(conn, :create), session: %{}
      assert get_flash(conn, :error) == "Invalid credentials"
    end
  end

  describe "API login" do
    @create_attrs %{name: "some name", email: "some email", password: "some password"}
    @login_attrs %{email: "some email", password: "some password"}
    @invalid_attrs %{email: nil, password: nil}

    setup %{conn: conn} do
      {:ok, conn: put_req_header(conn, "accept", "application/json")}
    end

    test "logs the user in and sends the jwt when data is valid", %{conn: conn} do
      Account.create_user(@create_attrs)
      conn = post conn, api_session_path(conn, :create), session: @login_attrs
      assert %{"id" => _id} = json_response(conn, 201)["data"]["user"]
      assert %{"jwt" => _jwt} = json_response(conn, 201)["data"]
      auth_header = Enum.find(conn.resp_headers, fn x -> elem(x, 0) == "authorization" end)
      assert {_, "Bearer" <> _} = auth_header
    end

    test "does not log the user in and renders a 401 unauthorized error when data is invalid", %{conn: conn} do
      conn = post conn, api_session_path(conn, :create), session: @invalid_attrs
      assert json_response(conn, 401)["errors"] != %{}
    end

    test "does not log the user in and renders a 401 unauthorized error when data is missing", %{conn: conn} do
      conn = post conn, api_session_path(conn, :create), session: %{}
      assert json_response(conn, 401)["errors"] != %{}
    end
  end
end
