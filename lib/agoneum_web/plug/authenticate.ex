defmodule Agoneum.Plug.Authenticate do
  alias Agoneum.{Account, Account.User}
  import Plug.Conn

  @behaviour Plug

  @moduledoc ""

  @impl true
  def init(opts) do
    opts
  end

  @impl true
  def call(conn, _opts) do
    assign_current_user(conn)
  end

  defp assign_current_user(%Plug.Conn{} = conn) do
    current_user = Guardian.Plug.current_resource(conn)
    assign_current_user(conn, current_user)
  end
  defp assign_current_user(conn, %User{} = user) do
    # Reload the current user from the database to pick up any changes
    user = Account.get_user(user.id)
    assign(conn, :current_user, user)
  end
  defp assign_current_user(conn, _) do
    assign(conn, :current_user, nil)
  end
end

