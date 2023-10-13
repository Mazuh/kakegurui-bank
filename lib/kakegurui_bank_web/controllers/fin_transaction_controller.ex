defmodule KakeguruiBankWeb.FinTransactionController do
  use KakeguruiBankWeb, :controller

  alias KakeguruiBank.Financial
  alias KakeguruiBank.Financial.FinTransaction

  action_fallback KakeguruiBankWeb.FallbackController

  def index(conn, _params) do
    fin_transactions = Financial.list_fin_transactions()
    render(conn, :index, fin_transactions: fin_transactions)
  end

  def create(conn, %{"amount" => amount, "receiver_cpf" => receiver_cpf}) do
    case Financial.create_fin_transaction(%{
           "current_user" => conn.assigns.current_user,
           "amount" => amount,
           "receiver_cpf" => receiver_cpf
         }) do
      {:ok, %FinTransaction{} = fin_transaction} ->
        conn
        |> put_status(:created)
        |> render(:show, fin_transaction: fin_transaction)

      {:logical_error, message} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: message})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: changeset |> changeset_error_to_string()})
    end
  end

  defp changeset_error_to_string(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.reduce("", fn {k, v}, acc ->
      joined_errors = Enum.join(v, "; ")
      "#{acc}#{k}: #{joined_errors};"
    end)
  end
end
