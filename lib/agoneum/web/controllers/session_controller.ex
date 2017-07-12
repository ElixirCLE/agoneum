defmodule Agoneum.Web.SessionController do
  use Agoneum.Web, :controller

  alias Agoneum.Account.Session

  action_fallback Agoneum.Web.FallbackController

  plug :scrub_params, "session" when action in [:create]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => session_params}) do
    create(conn, session_params, conn |> get_format() |> String.to_atom())
  end
  defp create(conn, session_params, :html) do
    case Session.authenticate(session_params) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid credentials")
        |> render(:new)
    end
  end
  defp create(conn, session_params, :json) do
    with {:ok, user} <- Session.authenticate(session_params) do
        new_conn = Guardian.Plug.api_sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)
        {:ok, claims} = Guardian.Plug.claims(new_conn)
        exp = Map.get(claims, "exp")

        new_conn
        |> put_status(:created)
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", "#{exp}")
        |> render("show.json", user: user, jwt: jwt, exp: exp)
    end
  end

  def delete(conn, params) do
    delete(conn, params, conn |> get_format() |> String.to_atom())
  end
  defp delete(conn, _, :html) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "Successfully logged out")
    |> redirect(to: session_path(conn, :new))
  end
  defp delete(conn, _, :json) do
    jwt = Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.claims(conn)
    Guardian.revoke!(jwt, claims)
    render(conn, "logout.json")
  end
end
