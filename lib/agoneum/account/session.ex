defmodule Agoneum.Account.Session do
  @moduledoc ""
  alias Agoneum.Account
  alias Agoneum.Account.User

  @spec authenticate(map(), map()) :: {:ok, %User{}} | {:error, :invalid_credentials}
  def authenticate(params, auth \\ %{provider: :identity, info: %{}}) do
    authenticate(auth.provider, params, auth.info)
  end
  defp authenticate(:identity, %{"session" => %{"email" => email, "password" => password}}, _) do
    user = Account.get_user_by_email(email)

    case check_password(user, password) do
      true -> {:ok, user}
      _    -> {:error, :invalid_credentials}
    end
  end
  defp authenticate(:identity, _, _), do: {:error, :invalid_credentials}
  defp authenticate(_, _, %Ueberauth.Auth.Info{email: email, name: name}) do
    case Account.get_user_by_email(email) do
      nil ->
        # Create the user if they do not already exist
        Account.create_user_admin(%{email: email, name: name})
      user ->
        {:ok, user}
    end
  end

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
