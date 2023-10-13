defmodule KakeguruiBankWeb.UserJSON do
  alias KakeguruiBank.Auth.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      cpf: user.cpf,
      first_name: user.first_name,
      last_name: user.last_name,
      inserted_at: user.inserted_at
    }
  end
end
