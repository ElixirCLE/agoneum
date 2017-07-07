defmodule Agoneum.Web.PageController do
  use Agoneum.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
