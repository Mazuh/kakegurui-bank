defmodule KakeguruiBank.Financial do
  @moduledoc """
  The Financial context.
  """

  import Ecto.Query, warn: false
  alias KakeguruiBank.Repo

  alias KakeguruiBank.Auth
  alias KakeguruiBank.Financial.FinTransaction

  @doc """
  Returns the list of fin_transactions.

  ## Examples

      iex> list_fin_transactions()
      [%FinTransaction{}, ...]

  """
  def list_fin_transactions do
    Repo.all(FinTransaction)
  end

  @doc """
  Gets a single fin_transaction.

  Raises `Ecto.NoResultsError` if the Fin transaction does not exist.

  ## Examples

      iex> get_fin_transaction!(123)
      %FinTransaction{}

      iex> get_fin_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fin_transaction!(id), do: Repo.get!(FinTransaction, id)

  def list_fin_transactions_of_user_id!(user_id) do
    Repo.all(
      from t in FinTransaction,
        where: t.sender_id == ^user_id or t.receiver_id == ^user_id,
        order_by: [desc: t.processed_at]
    )
  end

  def get_balance_of_user_id!(user_id) do
    query =
      from t in FinTransaction,
        where:
          (t.sender_id == ^user_id or t.receiver_id == ^user_id) and not is_nil(t.processed_at),
        select:
          fragment(
            "(
              SUM(
                CASE
                  WHEN receiver_id = ?
                  THEN amount
                  ELSE 0
                END
              )
              -
              SUM(
                CASE
                  WHEN receiver_id != ? AND sender_id = ?
                  THEN amount
                  ELSE 0
                END
              )
            ) AS balance",
            ^user_id,
            ^user_id,
            ^user_id
          )

    Repo.one!(query)
  end

  @doc """
  Creates a fin_transaction.

  ## Examples

      iex> create_fin_transaction(%{field: value})
      {:ok, %FinTransaction{}}

      iex> create_fin_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fin_transaction(%{
        "current_user" => current_user,
        "amount" => amount,
        "receiver_cpf" => receiver_cpf
      }) do
    sender = Auth.get_user_by_cpf(receiver_cpf)

    if sender == nil do
      {:logical_error, "Receiver does not exist"}
    else
      %FinTransaction{}
      |> FinTransaction.changeset(%{
        uuid: Ecto.UUID.generate(),
        amount: amount,
        # TODO: async task may be an overkill here but it's a good plan! 🤘🏽
        processed_at: DateTime.utc_now(),
        sender_id: current_user.id,
        sender_info_cpf: current_user.cpf,
        receiver_id: sender.id,
        receiver_info_cpf: sender.cpf
      })
      |> Repo.insert()
    end
  end
end
