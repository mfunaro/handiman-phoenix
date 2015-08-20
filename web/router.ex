defmodule Handiman.Router do
  use Handiman.Web, :router

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

  scope "/", Handiman do
    pipe_through :browser # Use the default browser stack

    get  "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    get "/", PageController, :index
    resources "/users", UserController do
      resources "/rounds", RoundController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Handiman do
  #   pipe_through :api
  # end
end
