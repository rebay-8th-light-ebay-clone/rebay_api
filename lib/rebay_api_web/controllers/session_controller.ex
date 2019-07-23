defmodule RebayApiWeb.SessionController do
  use RebayApiWeb, :controller
  plug Ueberauth

  alias RebayApi.Repo
  alias RebayApi.Accounts.User

  def create(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      avatar: auth.info.image,
      email: auth.info.email,
      first_name: auth.info.first_name,
      provider: "google",
      token: auth.credentials.token,
      uuid: Ecto.UUID.generate() 
    }

    changeset = User.changeset(%User{}, user_params)

    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.user_path(conn, :show, user.uuid))
      {:error, %Ecto.Changeset{} = changeset} -> 
        conn
        |> put_view(RebayApiWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil -> 
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end