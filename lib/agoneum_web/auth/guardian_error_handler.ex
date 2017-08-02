defmodule AgoneumWeb.GuardianErrorHandler do
  import AgoneumWeb.Router.Helpers

  @moduledoc ""

  # TODO: Find a better way to do this that will work with an API
  def unauthenticated(conn, _params) do
    conn
    |> Phoenix.Controller.put_flash(:error, "You must be logged in to do that")
    |> Phoenix.Controller.redirect(to: session_path(conn, :new))
  end

  # TODO: Find a better way to do this that will work with an API
  def no_resource(conn, _params) do
    conn
    |> Agoneum.Account.Session.logout()
    |> Phoenix.Controller.redirect(to: page_path(conn, :index))
  end
end
