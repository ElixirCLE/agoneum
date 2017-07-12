defmodule Agoneum.Web.RegistrationControllerTest do
  use Agoneum.Web.ConnCase

  describe "UI registration" do
    @create_attrs %{email: "some email", name: "some name", password: "some password", password_confirmation: "some password"}
    @invalid_attrs %{email: nil, name: nil, password: nil, password_confirmation: nil}

    setup %{conn: conn} do
      {:ok, conn: put_req_header(conn, "accept", "application/json")}
    end

    test "creates user and sends the jwt when data is valid", %{conn: conn} do
      conn = post conn, api_registration_path(conn, :create), user: @create_attrs
      assert %{"id" => _id} = json_response(conn, 201)["data"]["user"]
      assert %{"jwt" => _jwt} = json_response(conn, 201)["data"]
      auth_header = Enum.find(conn.resp_headers, fn x -> elem(x, 0) == "authorization" end)
      assert {_, "Bearer" <> _} = auth_header
    end

    test "does not create user and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_registration_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "API registration" do
    @create_attrs %{email: "some email", name: "some name", password: "some password"}
    @invalid_attrs %{email: nil, name: nil, password: nil}

    setup %{conn: conn} do
      {:ok, conn: put_req_header(conn, "accept", "application/json")}
    end

    test "creates user and sends the jwt when data is valid", %{conn: conn} do
      conn = post conn, api_registration_path(conn, :create), user: @create_attrs
      assert %{"id" => _id} = json_response(conn, 201)["data"]["user"]
      assert %{"jwt" => _jwt} = json_response(conn, 201)["data"]
      auth_header = Enum.find(conn.resp_headers, fn x -> elem(x, 0) == "authorization" end)
      assert {_, "Bearer" <> _} = auth_header
    end

    test "does not create user and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_registration_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
