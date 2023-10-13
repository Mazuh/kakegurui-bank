defmodule KakeguruiBankWeb.FinTransactionJSON do
  alias KakeguruiBank.Financial.FinTransaction

  @doc """
  Renders a list of fin_transactions.
  """
  def index(%{fin_transactions: fin_transactions}) do
    %{data: for(fin_transaction <- fin_transactions, do: data(fin_transaction))}
  end

  @doc """
  Renders a single fin_transaction.
  """
  def show(%{fin_transaction: fin_transaction}) do
    %{data: data(fin_transaction)}
  end

  defp data(%FinTransaction{} = fin_transaction) do
    %{
      id: fin_transaction.id,
      uuid: fin_transaction.uuid,
      sender_info_cpf: fin_transaction.sender_info_cpf,
      receiver_info_cpf: fin_transaction.receiver_info_cpf,
      amount: fin_transaction.amount,
      processed_at: fin_transaction.processed_at
    }
  end
end
