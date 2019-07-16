defmodule RebayApiWeb.Router do
  use RebayApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RebayApiWeb do
    pipe_through :api
    resources "/items", ItemController, except: [:new, :edit]
  end
end
