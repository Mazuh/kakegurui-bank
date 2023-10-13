defmodule KakeguruiBankWeb.AuthenticationCheckController do
  use KakeguruiBankWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{first_name: conn.assigns.current_user.first_name})
  end
end
