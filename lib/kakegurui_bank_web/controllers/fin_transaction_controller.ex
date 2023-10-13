defmodule KakeguruiBankWeb.FinTransactionController do
  use KakeguruiBankWeb, :controller

  alias KakeguruiBank.Financial
  alias KakeguruiBank.Financial.FinTransaction

  action_fallback KakeguruiBankWeb.FallbackController

  def index(conn, _params) do
    fin_transactions = Financial.list_fin_transactions()
    render(conn, :index, fin_transactions: fin_transactions)
  end

  def create(conn, %{"fin_transaction" => fin_transaction_params}) do
    with {:ok, %FinTransaction{} = fin_transaction} <-
           Financial.create_fin_transaction(fin_transaction_params) do
      conn
      |> put_status(:created)
      |> render(:show, fin_transaction: fin_transaction)
    end
  end
end
