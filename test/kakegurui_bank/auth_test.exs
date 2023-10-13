defmodule KakeguruiBank.AuthTest do
  use KakeguruiBank.DataCase

  alias KakeguruiBank.Auth

  describe "users" do
    alias KakeguruiBank.Auth.User

    import KakeguruiBank.AuthFixtures

    @invalid_attrs %{first_name: nil, last_name: nil, cpf: nil, hash_pass: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{first_name: "some first_name", last_name: "some last_name", cpf: "some cpf", hash_pass: "some hash_pass"}

      assert {:ok, %User{} = user} = Auth.create_user(valid_attrs)
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.cpf == "some cpf"
      assert user.hash_pass == "some hash_pass"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{first_name: "some updated first_name", last_name: "some updated last_name", cpf: "some updated cpf", hash_pass: "some updated hash_pass"}

      assert {:ok, %User{} = user} = Auth.update_user(user, update_attrs)
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.cpf == "some updated cpf"
      assert user.hash_pass == "some updated hash_pass"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user == Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end
  end
end
