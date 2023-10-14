defmodule KakeguruiBank.FinancialTest do
  use KakeguruiBank.DataCase

  alias KakeguruiBank.Financial

  describe "fin_transactions" do
    alias KakeguruiBank.Financial.FinTransaction

    import KakeguruiBank.AuthFixtures

    test "list_fin_transactions/0 returns all fin_transactions" do
      assert length(Financial.list_fin_transactions()) == 0
    end

    test "create_fin_transaction/1 with valid request data creates a financial transaction" do
      sender = user_fixture(%{"cpf" => "111.111.111-11", "initial_balance" => 1000})
      receiver = user_fixture(%{"cpf" => "222.222.222-22", "initial_balance" => 1000})

      payload = %{
        "receiver_cpf" => receiver.cpf,
        "amount" => "120.5",
        "current_user" => sender
      }

      assert {:ok, %FinTransaction{} = fin_transaction} =
               Financial.create_fin_transaction(payload)

      assert fin_transaction.uuid != nil
      assert fin_transaction.sender_info_cpf == sender.cpf
      assert fin_transaction.receiver_info_cpf == receiver.cpf
      assert fin_transaction.amount == Decimal.new("120.5")
      assert fin_transaction.processed_at != nil
    end

    test "list_fin_transactions_of_user_id!/1 returns all fin_transactions related to a given user" do
      # users, the protagonist here would be the sender
      sender = user_fixture(%{"cpf" => "111.111.111-11", "initial_balance" => "200.00"})
      receiver = user_fixture(%{"cpf" => "222.222.222-22", "initial_balance" => "200.00"})

      out_of_scope_receiver =
        user_fixture(%{"cpf" => "333.333.333-33", "initial_balance" => "200.00"})

      # deposit to themself
      {:ok, deposit} =
        Financial.create_fin_transaction(%{
          "current_user" => sender,
          "receiver_cpf" => sender.cpf,
          "amount" => "100.00"
        })

      # transfer to a receiver
      {:ok, transfer} =
        Financial.create_fin_transaction(%{
          "current_user" => sender,
          "receiver_cpf" => receiver.cpf,
          "amount" => "49.99"
        })

      # cashback from receiver
      {:ok, cashback} =
        Financial.create_fin_transaction(%{
          "current_user" => receiver,
          "receiver_cpf" => sender.cpf,
          "amount" => "00.05"
        })

      # out of scope transfer (to be ignored in the listing more ahead)
      Financial.create_fin_transaction(%{
        "current_user" => receiver,
        "receiver_cpf" => out_of_scope_receiver.cpf,
        "amount" => "666.66"
      })

      # the initial balance, deposit, transfer and cashback should be listed,
      # but not the out of scope transaction,
      # nor the initial balance from the other users
      fin_transactions = Financial.list_fin_transactions_of_user_id!(sender.id)
      assert length(fin_transactions) == 4

      assert Enum.at(fin_transactions, 0).amount == Decimal.new("200.00")

      assert Enum.at(fin_transactions, 1).id == deposit.id
      assert Enum.at(fin_transactions, 1).amount == Decimal.new("100.00")

      assert Enum.at(fin_transactions, 2).amount == Decimal.new("49.99")
      assert Enum.at(fin_transactions, 2).id == transfer.id

      assert Enum.at(fin_transactions, 3).amount == Decimal.new("0.05")
      assert Enum.at(fin_transactions, 3).id == cashback.id

      # its balance after all of this
      assert Financial.get_balance_for_user_id!(sender.id) == Decimal.new("250.06")
    end
  end
end
