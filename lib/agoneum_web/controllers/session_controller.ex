defmodule AgoneumWeb.SessionController do
  use AgoneumWeb, :controller

  alias Agoneum.Account.Session
  alias Ueberauth.Strategy.Helpers

  action_fallback AgoneumWeb.FallbackController

  plug :scrub_params, "session" when action in [:create]
  plug Ueberauth

  def request(conn, _params) do
    render(conn, "new.html", callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_faulure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate")
    |> redirect(to: session_path(conn, :request, :identity))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, session_params) do
    case Session.authenticate(session_params, auth) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid credentials")
        |> redirect(to: session_path(conn, :request, :identity))
    end
  end

  def create(conn, session_params) do
    with {:ok, user} <- Session.authenticate(session_params),
         new_conn <- Guardian.Plug.api_sign_in(conn, user) do
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
    |> redirect(to: session_path(conn, :request, :identity))
  end
  defp delete(conn, _, :json) do
    jwt = Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.claims(conn)
    Guardian.revoke!(jwt, claims)
    render(conn, "logout.json")
  end
end
