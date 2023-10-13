defmodule KakeguruiBankWeb.UserController do
  use KakeguruiBankWeb, :controller

  alias KakeguruiBank.Auth
  alias KakeguruiBank.Auth.User

  action_fallback KakeguruiBankWeb.FallbackController

  def create(conn, user_params) do
    with {:ok, %User{} = user} <- Auth.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, :show, user: user)
  end
end
