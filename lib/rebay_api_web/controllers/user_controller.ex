defmodule RebayApiWeb.UserController do
  use RebayApiWeb, :controller

  alias RebayApi.Accounts
  alias RebayApi.Accounts.User

  action_fallback RebayApiWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"uuid" => uuid}) do
    user = Accounts.get_user!(uuid)
    render(conn, "show.json", user: user)
  end
end
