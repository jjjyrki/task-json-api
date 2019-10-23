defmodule TaskApiWeb.TodoControllerTest do
  use TaskApiWeb.ConnCase

  alias TaskApi.Tasks
  alias TaskApi.Tasks.Todo
  alias TaskApi.Repo
  alias TaskApi.Accounts.User

  setup %{conn: conn} do
    conn = conn
    |> put_req_header("accept", "application/json")
    |> set_authorization_header()

    {:ok, conn: conn}
  end

  def todo_fixture() do
    {:ok, user} = TaskApi.Accounts.create_user(%{
      name: "auth",
      email: "auth@user.foo",
      password: "password"
    })

    {:ok, todo} = Tasks.create_todo(%{
      description: "description",
      title: "title",
      done: false,
      user: user
    })
    
    todo
  end

  describe "index" do
    test "lists all todos", %{conn: conn} do
      conn = get(conn, Routes.todo_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create todo" do
    test "renders todo when data is valid", %{conn: conn} do
      #todo = todo_fixture()
      user = Repo.get_by(User, %{email: "auth@user.foo"})
      IO.inspect(user)
      conn = post(conn, Routes.todo_path(conn, :create), todo: %{
        description: "description",
        title: "title",
        done: false,
        user: user
      })
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.todo_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.todo_path(conn, :create), todo: %{
        description: nil,
        title: nil,
      })
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update todo" do
    setup [:create_todo]

    test "renders todo when data is valid", %{conn: conn, todo: %Todo{id: id} = todo} do
      conn = put(conn, Routes.todo_path(conn, :update, todo), todo: %{
        description: "update description",
        title: "update title",
        done: true
      })
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.todo_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todo: todo} do
      conn = put(conn, Routes.todo_path(conn, :update, todo), todo: %{})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete todo" do
    setup [:create_todo]

    test "deletes chosen todo", %{conn: conn, todo: todo} do
      conn = delete(conn, Routes.todo_path(conn, :delete, todo))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.todo_path(conn, :show, todo))
      end
    end
  end

  defp create_todo(_) do
    user = create_user()
    {:ok, todo} = Tasks.create_todo(%{
      description: "description",
      title: "title",
      done: false,
      user: user
    })

    {:ok, todo: todo}
  end

  def create_user() do
    {:ok, user} = TaskApi.Accounts.create_user(%{
      name: "auth",
      email: "auth@user.foo",
      password: "password"
    })

    user
  end

  defp set_authorization_header(conn) do
    user = create_user()
    {:ok, auth_token} = TaskApi.Accounts.User.sign_in(user.email, user.password)
    conn
    |> put_req_header("authorization", "Bearer " <> auth_token.token)
  end
end
