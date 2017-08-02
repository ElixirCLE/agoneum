defmodule Agoneum.Account.Session do
  @moduledoc ""
  alias Agoneum.Account
  alias Agoneum.Account.User

  @spec authenticate(map()) :: {:ok, %User{}} | {:error, :invalid_credentials}
  def authenticate(%{"email" => email, "password" => password}) do
    user = Account.get_user_by_email(email)

    case check_password(user, password) do
      true -> {:ok, user}
      _    -> {:error, :invalid_credentials}
    end
  end
  def authenticate(_), do: {:error, :invalid_credentials}

  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def logout(conn) do
    logout(conn, conn |> Phoenix.Controller.get_format() |> String.to_atom())
  end
  defp logout(conn, :html) do
    conn
    |> Guardian.Plug.sign_out()
  end
  defp logout(conn, :json) do
    jwt = Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.claims(conn)
    Guardian.revoke!(jwt, claims)
    conn
  end

  def logged_in?(conn), do: !!current_user(conn)

  @spec check_password(nil | %User{}, String.t) :: boolean()
  defp check_password(nil, _), do: Comeonin.Bcrypt.dummy_checkpw
  defp check_password(%User{} = user, password) do
    Comeonin.Bcrypt.checkpw(password, user.password_hash)
  end
end
