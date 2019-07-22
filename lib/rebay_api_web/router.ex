defmodule RebayApiWeb.Router do
  use RebayApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/api", RebayApiWeb do
    pipe_through :api
    resources "/items", ItemController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
  end

  scope "/auth", RebayAPIWeb do
    pipe_through :auth
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
