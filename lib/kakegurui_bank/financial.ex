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
