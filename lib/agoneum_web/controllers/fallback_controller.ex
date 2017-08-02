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

  def call(conn, {:error, :invalid_credentials}) do
    conn
    |> put_status(:unauthorized)
    |> render(AgoneumWeb.ErrorView, :"401_invalid_credentials")
  end

  def call(conn, {:error, :unauthenticated}) do
    conn
    |> put_status(:forbidden)
    |> render(AgoneumWeb.ErrorView, :"403_unauthenticated")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(AgoneumWeb.ErrorView, :"404")
  end
end
