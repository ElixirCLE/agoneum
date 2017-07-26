defmodule AgoneumWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use AgoneumWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(AgoneumWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(AgoneumWeb.ErrorView, :"404")
  end

  def call(conn, {:error, :invalid_credentials}) do
    conn
    |> put_status(:unauthorized)
    |> render(AgoneumWeb.ErrorView, :"401_invalid_credentials")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You must be logged in to do that")
    |> redirect(to: session_path(conn, :new))
  end
end
