defmodule KakeguruiBank.Financial do
  @moduledoc """
  The Financial context.
  """

  import Ecto.Query, warn: false
  alias KakeguruiBank.Repo

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
  def create_fin_transaction(attrs \\ %{}) do
    %FinTransaction{}
    |> FinTransaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fin_transaction.

  ## Examples

      iex> update_fin_transaction(fin_transaction, %{field: new_value})
      {:ok, %FinTransaction{}}

      iex> update_fin_transaction(fin_transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fin_transaction(%FinTransaction{} = fin_transaction, attrs) do
    fin_transaction
    |> FinTransaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a fin_transaction.

  ## Examples

      iex> delete_fin_transaction(fin_transaction)
      {:ok, %FinTransaction{}}

      iex> delete_fin_transaction(fin_transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fin_transaction(%FinTransaction{} = fin_transaction) do
    Repo.delete(fin_transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fin_transaction changes.

  ## Examples

      iex> change_fin_transaction(fin_transaction)
      %Ecto.Changeset{data: %FinTransaction{}}

  """
  def change_fin_transaction(%FinTransaction{} = fin_transaction, attrs \\ %{}) do
    FinTransaction.changeset(fin_transaction, attrs)
  end
end
