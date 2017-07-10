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
    case Account.create_user(user_params) do
      {:ok, %User{} = user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:new, changeset: changeset)
    end
  end
end
