defmodule TaskApiWeb.UserControllerTest do
  use TaskApiWeb.ConnCase

  alias TaskApi.Repo
  alias TaskApi.Accounts
  alias TaskApi.Accounts.User

  @current_user_attrs %{
    email: "current@user.fi",
    name: "some current user name",
    password: "some current user password"
  }

  @create_attrs %{
    email: "some@email.foo",
    name: "some name",
    password: "some password"
  }

  @update_attrs %{
    email: "some_updated@email.fi",
    name: "some updated name",
    password: "some updated password"
  }

  @invalid_attrs %{
    email: nil,
    name: nil,
    password: nil
  }

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  def fixture(:current_user) do
    {:ok, current_user} = Accounts.create_user(@current_user_attrs)
    current_user
  end

  setup %{conn: conn} do
    {:ok, conn, current_user} = setup_current_user(conn)
    {:ok, conn: put_req_header(conn, "accept", "application/json"), current_user: current_user}
  end

  def add_authentication(conn, current_user) do
    {:ok, token} = User.sign_in(current_user.email, current_user.password)
    
    conn
    |> put_req_header("authorization", "Bearer " <> token.token) 
  end

  describe "index" do
    test "lists all users", %{conn: conn, current_user: current_user} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == [
        %{
          "user" => %{
            "email" => current_user.email,
            "name" => current_user.name
          }
        }
      ]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{
        "user" => %{
          "email" => "some@email.foo",
          "name" => "some name"
        }
      } = json_response(conn, 201)["data"]
      
      user = Repo.get_by(User, email: @create_attrs.email)
    
      conn = get(conn, Routes.user_path(conn, :show, user.id))

      assert %{
        "user" => %{
            "email" => "some@email.foo",
            "name" => "some name"
          }
        } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{
        "user" => %{
          "email" => "some_updated@email.fi",
          "name" => "some updated name"
        }
      } = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
        "user" => %{
          "email" => "some_updated@email.fi",
          "name" => "some updated name"
        }
       } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  describe "sign_in user" do
    test "renders user when user credentials are good", %{conn: conn, current_user: current_user} do
      conn = get(conn, Routes.user_path(conn, :show, current_user.id))
      assert %{
        "user" => %{
          "email" => "current@user.fi",
          "name" => "some current user name"
        }
      } = json_response(conn, 200)["data"]
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  defp setup_current_user(conn) do
    current_user = fixture(:current_user)
    {:ok, token} = User.sign_in(current_user.email, current_user.password)
    conn = conn
    |> put_req_header("authorization", "Bearer " <> token.token) 
    {:ok, conn, current_user}
  end

end
