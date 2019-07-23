defmodule RebayApiWeb.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias RebayApi.Repo

  alias RebayApi.Accounts.User

  def init(_params) do

  end

  def call(conn, _params)  do
    user_uuid = get_session(conn, :user_id) #get user_id from the session

    cond do
      user = user_uuid && Repo.get_by(User, uuid: user_uuid) -> #check if user exists in database and assign to user variable
        assign(conn, :user, user) #now assign user struct to the conn object
      true ->
        assign(conn, :user, nil)  #user not found in database, return nil, and conn object is un-changed.
    end
  end
end
