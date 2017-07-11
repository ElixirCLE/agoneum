defmodule Agoneum.Web.PageController do
  use Agoneum.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: Agoneum.Web.FallbackController

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render conn, "index.html", user: user
  end
end
