defmodule TaskApi.AccountsTest do
  use TaskApi.DataCase

  alias TaskApi.Accounts

  describe "users" do
    alias TaskApi.Accounts.User

    @valid_attrs %{
      email: "valid@email.foo",
      name: "valid name",
      password: "valid password"
    }

    @update_attrs %{}
    
    @invalid_attrs %{
      email: "invalid email format",
      name: nil,
      password: nil
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      users = Accounts.list_users()

      for u <- users do
        assert u.name == "valid name"
        assert u.email == "valid@email.foo"
      end
    end

    test "get_user!/1 returns the user with given id" do
      user = Accounts.get_user!(user_fixture().id)
      assert user.name == "valid name"
      assert user.email == "valid@email.foo"
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
    end

    test "update_user/2 with invalid data returns error changeset" do
      update_user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(update_user, @invalid_attrs)
      user = Accounts.get_user!(update_user.id)
      assert user.name == "valid name"
      assert user.email == "valid@email.foo"
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
