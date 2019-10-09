defmodule TaskApiWeb.Router do
  use TaskApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TaskApiWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
  end
end
