defmodule Agoneum.Web.Router do
  use Agoneum.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureResource
  end

  scope "/", Agoneum.Web do
    pipe_through :browser # Use the default browser stack

    resources "/registrations", RegistrationController, only: [:create, :new]
    post "/sessions", SessionController, :create

    get "/", PageController, :index
  end

  scope "/api", Agoneum.Web do
    pipe_through :api

    scope "/v1" do
      post "/registrations", RegistrationController, :create, as: :api_registration
      post "/sessions", SessionController, :create, as: :api_session
    end

    scope "/v1" do
      pipe_through :api_auth
    end
  end
end
