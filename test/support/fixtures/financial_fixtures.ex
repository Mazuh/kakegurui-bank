defmodule KakeguruiBank.FinancialFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `KakeguruiBank.Financial` context.
  """

  @doc """
  Generate a fin_transaction.
  """
  def fin_transaction_fixture(attrs \\ %{}) do
    {:ok, fin_transaction} =
      attrs
      |> Enum.into(%{
        uuid: "7488a646-e31f-11e4-aace-600308960662",
        sender_info_cpf: "some sender_info_cpf",
        receiver_info_cpf: "some receiver_info_cpf",
        amount: "120.5",
        processed_at: ~N[2023-10-12 11:26:00]
      })
      |> KakeguruiBank.Financial.create_fin_transaction()

    fin_transaction
  end
end
