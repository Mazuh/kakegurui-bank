defmodule KakeguruiBank.FinancialTest do
  use KakeguruiBank.DataCase

  alias KakeguruiBank.Financial

  describe "fin_transactions" do
    alias KakeguruiBank.Financial.FinTransaction

    import KakeguruiBank.FinancialFixtures

    @invalid_attrs %{uuid: nil, sender_info_cpf: nil, receiver_info_cpf: nil, amount: nil, processed_at: nil}

    test "list_fin_transactions/0 returns all fin_transactions" do
      fin_transaction = fin_transaction_fixture()
      assert Financial.list_fin_transactions() == [fin_transaction]
    end

    test "get_fin_transaction!/1 returns the fin_transaction with given id" do
      fin_transaction = fin_transaction_fixture()
      assert Financial.get_fin_transaction!(fin_transaction.id) == fin_transaction
    end

    test "create_fin_transaction/1 with valid data creates a fin_transaction" do
      valid_attrs = %{uuid: "7488a646-e31f-11e4-aace-600308960662", sender_info_cpf: "some sender_info_cpf", receiver_info_cpf: "some receiver_info_cpf", amount: "120.5", processed_at: ~N[2023-10-12 11:26:00]}

      assert {:ok, %FinTransaction{} = fin_transaction} = Financial.create_fin_transaction(valid_attrs)
      assert fin_transaction.uuid == "7488a646-e31f-11e4-aace-600308960662"
      assert fin_transaction.sender_info_cpf == "some sender_info_cpf"
      assert fin_transaction.receiver_info_cpf == "some receiver_info_cpf"
      assert fin_transaction.amount == Decimal.new("120.5")
      assert fin_transaction.processed_at == ~N[2023-10-12 11:26:00]
    end

    test "create_fin_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financial.create_fin_transaction(@invalid_attrs)
    end

    test "update_fin_transaction/2 with valid data updates the fin_transaction" do
      fin_transaction = fin_transaction_fixture()
      update_attrs = %{uuid: "7488a646-e31f-11e4-aace-600308960668", sender_info_cpf: "some updated sender_info_cpf", receiver_info_cpf: "some updated receiver_info_cpf", amount: "456.7", processed_at: ~N[2023-10-13 11:26:00]}

      assert {:ok, %FinTransaction{} = fin_transaction} = Financial.update_fin_transaction(fin_transaction, update_attrs)
      assert fin_transaction.uuid == "7488a646-e31f-11e4-aace-600308960668"
      assert fin_transaction.sender_info_cpf == "some updated sender_info_cpf"
      assert fin_transaction.receiver_info_cpf == "some updated receiver_info_cpf"
      assert fin_transaction.amount == Decimal.new("456.7")
      assert fin_transaction.processed_at == ~N[2023-10-13 11:26:00]
    end

    test "update_fin_transaction/2 with invalid data returns error changeset" do
      fin_transaction = fin_transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Financial.update_fin_transaction(fin_transaction, @invalid_attrs)
      assert fin_transaction == Financial.get_fin_transaction!(fin_transaction.id)
    end

    test "delete_fin_transaction/1 deletes the fin_transaction" do
      fin_transaction = fin_transaction_fixture()
      assert {:ok, %FinTransaction{}} = Financial.delete_fin_transaction(fin_transaction)
      assert_raise Ecto.NoResultsError, fn -> Financial.get_fin_transaction!(fin_transaction.id) end
    end

    test "change_fin_transaction/1 returns a fin_transaction changeset" do
      fin_transaction = fin_transaction_fixture()
      assert %Ecto.Changeset{} = Financial.change_fin_transaction(fin_transaction)
    end
  end
end
