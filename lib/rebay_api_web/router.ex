defmodule RebayApiWeb.Router do
  use RebayApiWeb, :router

  pipeline :auth do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug RebayApi.Plugs.SetUser
  end
  
  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug RebayApi.Plugs.SetUser
  end

  scope "/api", RebayApiWeb do
    pipe_through :api
    resources "/items", ItemController, only: [:index]
    resources "/items/:item_uuid/bids", BidController, except: [:new, :edit]
    resources "/users/:user_uuid/items", ItemController, except: [:new, :edit], param: "uuid", as: "user_item"
    resources "/users", UserController, except: [:new, :edit], param: "uuid"
  end

  scope "/auth", RebayApiWeb do
    pipe_through :auth

    get "/signout", SessionController, :delete
    get "/:provider", SessionController, :request
    get "/:provider/callback", SessionController, :create
  end
end
