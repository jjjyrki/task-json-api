defmodule TaskApiWeb.SessionsView do
    use TaskApiWeb, :view
    def render("show.json", auth_token) do
      %{data: %{token: auth_token.token}}
    end
  end