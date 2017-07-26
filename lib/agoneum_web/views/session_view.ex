defmodule AgoneumWeb.SessionView do
  use AgoneumWeb, :view
  alias AgoneumWeb.SessionView

  def render("show.json", %{user: user, jwt: jwt, exp: exp}) do
    %{data: %{
          user: render_one(user, SessionView, "user.json", as: :user),
          jwt: jwt,
          exp: exp
        }
     }
  end

  def render("user.json", %{user: user}) do
    %{
       id: user.id,
       name: user.name,
       email: user.email
     }
  end
end
