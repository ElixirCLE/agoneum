defmodule Agoneum.Web.LayoutView do
  use Agoneum.Web, :view

  alias Agoneum.Account.{Session, User}

  def current_user_name(conn) do
    user = Session.current_user(conn)
    user_display_name(user)
  end

  defp user_display_name(user) when not is_nil(user) do
    User.display_name(user)
  end
  defp user_display_name(_) do
    "Guest"
  end
end
