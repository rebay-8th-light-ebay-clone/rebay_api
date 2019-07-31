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
    resources "/users", UserController, except: [:new, :edit], param: "uuid" do
      resources "/items", ItemController, except: [:new, :edit], param: "uuid"
      get "/bids", BidController, :index_by_user
    end
    resources "/items", ItemController, only: [:index], param: "uuid" do
      resources "/bids", BidController, param: "uuid", only: [:create, :show]
      get "/bids", BidController, :index_by_item
    end
  end

  scope "/auth", RebayApiWeb do
    pipe_through :auth

    get "/signout", SessionController, :delete
    get "/:provider", SessionController, :request
    get "/:provider/callback", SessionController, :create
  end
end
