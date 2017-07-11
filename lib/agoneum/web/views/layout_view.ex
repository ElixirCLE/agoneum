defmodule Agoneum.Web.LayoutView do
  use Agoneum.Web, :view

  alias Agoneum.Account.Session

  def current_user_name(conn) do
    user = Session.current_user(conn)
    user_display_name(user)
  end
  defp user_display_name(nil) do
    "Guest"
  end
  defp user_display_name(user) do
    user_display_name(user.email, user.name)
  end
  defp user_display_name(email, nil) do
    email
  end
  defp user_display_name(_, name) do
    name
  end
end
