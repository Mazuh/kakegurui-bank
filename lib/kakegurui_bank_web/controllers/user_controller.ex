defmodule KakeguruiBankWeb.UserController do
  use KakeguruiBankWeb, :controller

  alias KakeguruiBank.Auth
  alias KakeguruiBank.Auth.User

  action_fallback KakeguruiBankWeb.FallbackController

  def create(conn, user_params) do
    with {:ok, %User{} = user} <- Auth.create_user(user_params) do
      conn
      |> put_status(:created)
      |> output_json(user)
    end
  end

  defp output_json(conn, %User{} = user) do
    conn
    |> json(%{
      "data" => %{
        "cpf" => user.cpf,
        "first_name" => user.first_name,
        "last_name" => user.last_name,
        "inserted_at" => user.inserted_at
      }
    })
  end
end
