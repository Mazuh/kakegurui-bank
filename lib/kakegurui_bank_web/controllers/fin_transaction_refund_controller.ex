defmodule KakeguruiBankWeb.FinTransactionRefundController do
  use KakeguruiBankWeb, :controller

  alias KakeguruiBank.Financial

  def index(conn, _params) do
    case Financial.refund_fin_transaction(%{
           "current_user_id" => conn.assigns.current_user.id,
           "fin_transaction_uuid" => conn.params["uuid"]
         }) do
      {:ok, fin_transaction} ->
        conn
        |> put_status(:ok)
        |> json(%{
          "fin_transaction_uuid" => fin_transaction.uuid,
          "refunded_at" => fin_transaction.refunded_at |> NaiveDateTime.to_string()
        })

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
