defmodule TaskApiWeb.Router do
  use TaskApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticate do
    plug TaskApiWeb.Plugs.Authenticate
  end

  scope "/api/v1/", TaskApiWeb do
    pipe_through :api
    post "/sign_up", UserController, :create
    resources "/tasks/todo", TodoController
  end

  scope "/api/v1/sessions", TaskApiWeb do
    pipe_through :api
    post "/sign_in", SessionsController, :create
    delete "/sign_out", SessionsController, :delete
  end

  scope "/api/v1", TaskApiWeb do
    pipe_through [:api, :authenticate]
    resources "/users", UserController, except: [:new, :edit]
  end

end
