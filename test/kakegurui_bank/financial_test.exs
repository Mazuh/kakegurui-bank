defmodule KakeguruiBank.FinancialTest do
  use KakeguruiBank.DataCase

  alias KakeguruiBank.Financial

  describe "fin_transactions" do
    alias KakeguruiBank.Financial.FinTransaction

    import KakeguruiBank.FinancialFixtures
    import KakeguruiBank.AuthFixtures

    test "list_fin_transactions/0 returns all fin_transactions" do
      fin_transaction = fin_transaction_fixture()
      assert Financial.list_fin_transactions() == [fin_transaction]
    end

    test "create_fin_transaction/1 with valid request data creates a financial transaction" do
      sender = user_fixture(%{cpf: "111.111.111-11"})
      receiver = user_fixture(%{cpf: "222.222.222-22"})

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
  end
end
