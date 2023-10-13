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
    with {:ok, %FinTransaction{} = fin_transaction} <- Financial.create_fin_transaction(fin_transaction_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/fin_transactions/#{fin_transaction}")
      |> render(:show, fin_transaction: fin_transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    fin_transaction = Financial.get_fin_transaction!(id)
    render(conn, :show, fin_transaction: fin_transaction)
  end

  def update(conn, %{"id" => id, "fin_transaction" => fin_transaction_params}) do
    fin_transaction = Financial.get_fin_transaction!(id)

    with {:ok, %FinTransaction{} = fin_transaction} <- Financial.update_fin_transaction(fin_transaction, fin_transaction_params) do
      render(conn, :show, fin_transaction: fin_transaction)
    end
  end

  def delete(conn, %{"id" => id}) do
    fin_transaction = Financial.get_fin_transaction!(id)

    with {:ok, %FinTransaction{}} <- Financial.delete_fin_transaction(fin_transaction) do
      send_resp(conn, :no_content, "")
    end
  end
end
