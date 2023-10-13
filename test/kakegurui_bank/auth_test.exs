defmodule KakeguruiBank.AuthTest do
  use KakeguruiBank.DataCase

  alias KakeguruiBank.Auth
  alias KakeguruiBank.Financial

  describe "users" do
    alias KakeguruiBank.Auth.User

    import KakeguruiBank.AuthFixtures

    @valid_attrs %{
      "first_name" => "João",
      "last_name" => "da Silva",
      "cpf" => "052.490.668-87",
      "pass" => "some hash_pass"
    }

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "get_user_by_cpf/1 returns the user by its CPF" do
      user_fixture(%{cpf: "666.666.666-66"})
      assert Auth.get_user_by_cpf("666.666.666-66").cpf == "666.666.666-66"
    end

    test "get_user_by_cpf/1 returns nil if no user with given CPF is found" do
      assert Auth.get_user_by_cpf("666.666.666-66") == nil
    end

    test "get_user_by_cpf!/1 returns the user by its CPF" do
      user_fixture(%{cpf: "666.666.666-66"})
      assert Auth.get_user_by_cpf("666.666.666-66").cpf == "666.666.666-66"
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.first_name == "João"
      assert user.last_name == "da Silva"
      assert user.cpf == "052.490.668-87"
    end

    test "create_user/1 with initial amount will create a first transaction" do
      attrs = @valid_attrs |> Map.put("initial_balance", "1000.00")
      {:ok, _} = Auth.create_user(attrs)
      user = Auth.get_user_by_cpf!("052.490.668-87")
      transactions = Financial.list_fin_transactions_of_user_id!(user.id)
      assert length(transactions) == 1
    end

    test "create_user/1 does not allow duplicated cpf" do
      {:ok, %User{} = _original_user} = Auth.create_user(@valid_attrs)

      assert {:error, %Ecto.Changeset{} = changeset} = Auth.create_user(@valid_attrs)
      assert [cpf: {"has already been taken", _}] = changeset.errors
    end

    test "create_user/1 checks invalid cpf" do
      invalid_cpf = @valid_attrs |> Map.put("cpf", "11122233344")
      {:error, %Ecto.Changeset{} = changeset} = Auth.create_user(invalid_cpf)
      assert [cpf: {"has invalid format", _}] = changeset.errors
    end
  end
end
