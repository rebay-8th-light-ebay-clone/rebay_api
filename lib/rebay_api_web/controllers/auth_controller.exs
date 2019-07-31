defmodule RebayApiWeb.AuthController do
  use RebayApiWeb, :controller

  action_fallback RebayApiWeb.FallbackController

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{
      avatar: auth.info.picture,
      email: auth.info.email,
      first_name: auth.info.given_name,
      provider: "google",
      token: auth.credentials.token,
      uuid: auth.uid
    }
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  defp signin(conn, changeset) do
    {:ok, user} = insert_or_update_user(changeset)
    conn
    |> put_session(:user_id, user.uuid)
    |> redirect_to(to: user_path(conn, :show, user))
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: developer_path(conn, :index))
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, uuid: changeset.changes.uuid) do
        nil ->
          Repo.insert(changeset)
        user ->
          {:ok, user}
        end
  end
end
