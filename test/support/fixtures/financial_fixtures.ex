defmodule KakeguruiBank.FinancialFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `KakeguruiBank.Financial` context.
  """

  import KakeguruiBank.AuthFixtures

  @doc """
  Generate a fin_transaction.
  """
  def fin_transaction_fixture(attrs \\ %{}) do
    sender = user_fixture(%{"cpf" => "111.111.111-11", "initial_balance" => 1000})
    receiver = user_fixture(%{"cpf" => "222.222.222-22", "initial_balance" => 1000})

    {:ok, fin_transaction} =
      attrs
      |> Enum.into(%{
        "receiver_cpf" => receiver.cpf,
        "amount" => "120.5",
        "current_user" => sender
      })
      |> KakeguruiBank.Financial.create_fin_transaction()

    fin_transaction
  end
end
