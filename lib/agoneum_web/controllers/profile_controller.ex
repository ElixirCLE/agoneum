defmodule AgoneumWeb.ProfileController do
  use AgoneumWeb, :controller
  alias Agoneum.{Account, Account.Session}

  def edit(conn, _params) do
    user = Session.current_user(conn)
    changeset = Account.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user = Session.current_user(conn)
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
