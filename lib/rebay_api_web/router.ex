defmodule RebayApiWeb.Router do
  use RebayApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RebayApiWeb do
    pipe_through :api
  end
end
