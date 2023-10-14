defmodule KakeguruiBankWeb.FinTransactionController do
  use KakeguruiBankWeb, :controller

  alias KakeguruiBank.Financial
  alias KakeguruiBank.Financial.FinTransaction

  action_fallback KakeguruiBankWeb.FallbackController

  def index(conn, _params) do
    from_processed_at_date = conn.query_params["from_processed_at"]
    {:ok, from_processed_at} = NaiveDateTime.from_iso8601("#{from_processed_at_date}T00:00:00")

    to_processed_at_date = conn.query_params["to_processed_at"]

    {:ok, to_processed_at} =
      NaiveDateTime.from_iso8601("#{to_processed_at_date}T00:00:00")

    to_processed_at = NaiveDateTime.add(to_processed_at, 1, :day)

    fin_transactions =
      Financial.list_fin_transactions(%{
        "current_user" => conn.assigns.current_user,
        "from_processed_at" => from_processed_at,
        "to_processed_at" => to_processed_at
      })

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
