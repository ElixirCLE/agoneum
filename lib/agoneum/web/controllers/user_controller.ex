defmodule Agoneum.Web.UserController do
  use Agoneum.Web, :controller
  alias Agoneum.Account

  plug :load_and_authorize_resource, model: Account.User

  def edit(conn, _params) do
    user = conn.assigns.user
    changeset = Account.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.user
    case Account.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end
