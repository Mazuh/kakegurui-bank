defmodule KakeguruiBank.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias KakeguruiBank.Repo

  alias KakeguruiBank.Auth.User

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_cpf!(cpf), do: Repo.get_by!(User, cpf: cpf)

  def get_user_by_cpf(cpf), do: Repo.get_by(User, cpf: cpf)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Verifies if a given user (with a provided raw password)
  matches some stored user (by its hashed password).
  """
  def verify_user(%{"cpf" => cpf, "pass" => pass}) do
    user = Repo.one!(User, cpf: cpf)

    if user != nil and Argon2.check_pass(%{password_hash: user.hash_pass}, pass) do
      {:ok, user}
    else
      {:error, "User verification failed"}
    end
  end
end
