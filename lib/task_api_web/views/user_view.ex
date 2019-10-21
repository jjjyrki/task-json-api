defmodule TaskApiWeb.UserView do
  use TaskApiWeb, :view
  alias TaskApiWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      user: %{
        name: user.name,
        email: user.email
      }
    }
  end
end
