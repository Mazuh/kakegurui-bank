defmodule KakeguruiBank.Financial do
  @moduledoc """
  The Financial context.
  """

  import Ecto.Query, warn: false
  alias KakeguruiBank.Repo

  alias KakeguruiBank.Auth
  alias KakeguruiBank.Financial.FinTransaction

  def list_fin_transactions do
    Repo.all(FinTransaction)
  end

  def list_fin_transactions(%{
        "current_user" => current_user,
        "from_processed_at" => from_processed_at,
        "to_processed_at" => to_processed_at
      }) do
    Repo.all(
      from t in FinTransaction,
        where:
          (t.sender_id == ^current_user.id or t.receiver_id == ^current_user.id) and
            t.processed_at >= ^from_processed_at and
            t.processed_at <= ^to_processed_at,
        order_by: [desc: t.processed_at]
    )
  end

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
            (t.sender_id == ^user_id or t.receiver_id == ^user_id) and
              not is_nil(t.processed_at) and is_nil(t.refunded_at),
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

  def refund_fin_transaction(%{
        "current_user_id" => current_user_id,
        "fin_transaction_uuid" => fin_transaction_uuid
      }) do
    {_, result} =
      Repo.transaction(fn ->
        # Repo.query!("SET TRANSACTION ISOLATION LEVEL READ COMMITTED;")
        Repo.query!("LOCK TABLE fin_transactions IN SHARE ROW EXCLUSIVE MODE;")

        fin_transaction =
          Repo.one(
            from t in FinTransaction,
              where:
                t.uuid == ^fin_transaction_uuid and
                  t.sender_id == ^current_user_id and
                  t.receiver_id != ^current_user_id and
                  not is_nil(t.processed_at) and
                  is_nil(t.refunded_at),
              lock: fragment("FOR UPDATE OF ?", t)
          )

        receiver_balance =
          if not is_nil(fin_transaction),
            do: get_balance_for_user_id!(fin_transaction.receiver_id),
            else: Decimal.new("0.0")

        cond do
          is_nil(fin_transaction) ->
            {:logical_error, "Unavailable for refund"}

          Decimal.lt?(receiver_balance, "0.0") ->
            # insuficient funds from receiver, but we cant risk personal banking detail about them
            # (previous bad state)
            {:logical_error, "Unavailable for refund"}

          Decimal.lt?(receiver_balance, fin_transaction.amount) ->
            # insuficient funds from receiver, but we cant risk personal banking detail about them
            {:logical_error, "Unavailable for refund"}

          true ->
            fin_transaction
            |> FinTransaction.changeset(%{"refunded_at" => DateTime.utc_now()})
            |> Repo.update()
        end
      end)

    result
  end

  def create_fin_transaction(%{
        "current_user" => sender,
        "amount" => amount,
        "receiver_cpf" => receiver_cpf
      }) do
    {:ok, fin_transaction} =
      Repo.transaction(fn ->
        sender_balance = get_balance_for_user_id!(sender.id)
        receiver = Auth.get_user_by_cpf(receiver_cpf)
        is_own_deposit = not is_nil(receiver) and sender.id == receiver.id

        cond do
          is_nil(receiver) ->
            {:logical_error, "Receiver is not available"}

          Decimal.lt?(sender_balance, "0.0") ->
            {:logical_error, "Insufficient funds due to previous invalid state"}

          Decimal.lt?(amount, "0.0") ->
            {:logical_error, "Only non-negative amounts are allowed"}

          not is_own_deposit && Decimal.lt?(sender_balance, amount) ->
            {:logical_error, "Insufficient funds"}

          true ->
            fin_transaction =
              %FinTransaction{}
              |> FinTransaction.changeset(%{
                uuid: Ecto.UUID.generate(),
                amount: amount,
                processed_at: DateTime.utc_now(),
                sender_id: sender.id,
                sender_info_cpf: sender.cpf,
                receiver_id: receiver.id,
                receiver_info_cpf: receiver.cpf
              })
              |> Repo.insert()

            if Decimal.lt?(get_balance_for_user_id!(sender.id), "0.0") do
              Repo.rollback({:logical_error, "Insufficient funds due to invalid post state"})
            else
              fin_transaction
            end
        end
      end)

    fin_transaction
  end
end
