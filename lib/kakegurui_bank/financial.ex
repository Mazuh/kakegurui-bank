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

  def get_balance_for_user_id!(user_id) do
    balance =
      Repo.one!(
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
      )

    if is_nil(balance) do
      Decimal.new("0.0")
    else
      {:ok, balance} = Decimal.cast(balance)
      balance
    end
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
        "current_user" => sender,
        "amount" => amount,
        "receiver_cpf" => receiver_cpf
      }) do
    sender_balance = get_balance_for_user_id!(sender.id)
    receiver = Auth.get_user_by_cpf(receiver_cpf)
    is_own_deposit = not is_nil(receiver) and sender.id == receiver.id

    cond do
      is_nil(receiver) ->
        {:logical_error, "Receiver is not available"}

      Decimal.lt?(amount, "0.0") ->
        {:logical_error, "Only non-negative amounts are allowed"}

      not is_own_deposit && Decimal.lt?(sender_balance, amount) ->
        {:logical_error, "Insufficient funds"}

      true ->
        %FinTransaction{}
        |> FinTransaction.changeset(%{
          uuid: Ecto.UUID.generate(),
          amount: amount,
          # TODO: async task may be an overkill here but it's a good plan! 🤘🏽
          processed_at: DateTime.utc_now(),
          sender_id: sender.id,
          sender_info_cpf: sender.cpf,
          receiver_id: receiver.id,
          receiver_info_cpf: receiver.cpf
        })
        |> Repo.insert()
    end
  end
end
