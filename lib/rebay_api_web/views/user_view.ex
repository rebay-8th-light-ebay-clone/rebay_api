defmodule RebayApiWeb.UserView do
  use RebayApiWeb, :view
  alias RebayApiWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{email: user.email,
      provider: user.provider,
      token: user.token,
      avatar: user.avatar,
      first_name: user.first_name,
      uuid: user.uuid}
  end
end
