defmodule AgoneumWeb.Router do
  use AgoneumWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :auth do
    plug Guardian.Plug.EnsureResource, handler: AgoneumWeb.GuardianErrorHandler
    plug Guardian.Plug.EnsureAuthenticated, handler: AgoneumWeb.GuardianErrorHandler
  end

  scope "/", AgoneumWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/registrations", RegistrationController, only: [:create, :new]
    resources "/login", SessionController, only: [:create, :new]
  end

  scope "/", AgoneumWeb do
    pipe_through [:browser, :auth]

    get "/profile/edit", ProfileController, :edit
    put "/profile/update/:id", ProfileController, :update

    delete "/logout", SessionController, :delete
  end

  scope "/api", AgoneumWeb do
    pipe_through :api

    scope "/v1" do
      resources "/sessions", SessionController, only: [:create, :new], as: :api_session
    end

    scope "/v1" do
      pipe_through :auth

      delete "/sessions", SessionController, :delete, as: :api_session
    end
  end
end
