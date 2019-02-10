defmodule AgoneumWeb.Router do
  use AgoneumWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureResource
  end

  scope "/", AgoneumWeb do
    pipe_through :browser # Use the default browser stack

    resources "/registrations", RegistrationController, only: [:create, :new]

    scope "/login" do
      get "/:provider", SessionController, :request
      get "/:provider/callback", SessionController, :callback
      post "/:provider/callback", SessionController, :callback
    end
    delete "/logout", SessionController, :delete
  end

  scope "/", AgoneumWeb do
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index
  end

  scope "/api", AgoneumWeb do
    pipe_through :api

    scope "/v1" do
      resources "/sessions", SessionController, only: [:create, :new], as: :api_session
      delete "/sessions", SessionController, :delete, as: :api_session
    end

    scope "/v1" do
      pipe_through :api_auth
    end
  end
end
