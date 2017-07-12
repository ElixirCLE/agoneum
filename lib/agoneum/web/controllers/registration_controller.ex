defmodule Agoneum.Web.RegistrationController do
  use Agoneum.Web, :controller

  alias Agoneum.Account
  alias Agoneum.Account.User

  action_fallback Agoneum.Web.FallbackController

  def new(conn, _params) do
    changeset = Account.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    type = conn |> get_format() |> String.to_atom()
    create(conn, user_params, type)
  end
  defp create(conn, user_params, :html) do
    case Account.create_user(user_params) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render(:new, changeset: changeset)
    end
  end
  defp create(conn, user_params, :json) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)

      conn
      |> put_status(:created)
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> render("registration.json", user: user, jwt: jwt)
    end
  end
end
