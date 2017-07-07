defmodule Agoneum.Web.RegistrationController do
  use Agoneum.Web, :controller

  alias Agoneum.Account
  alias Agoneum.Account.User

  action_fallback Agoneum.Web.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)

      conn
      |> put_status(:created)
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> render("registration.json", user: user, jwt: jwt)
    end
  end
end
