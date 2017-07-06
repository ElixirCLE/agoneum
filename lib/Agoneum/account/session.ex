defmodule Agoneum.Account.Session do
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

  @spec check_password(nil | %User{}, String.t) :: boolean()
  defp check_password(nil, _), do: Comeonin.Bcrypt.dummy_checkpw
  defp check_password(%User{} = user, password) do
    Comeonin.Bcrypt.checkpw(password, user.password_hash)
  end
end
