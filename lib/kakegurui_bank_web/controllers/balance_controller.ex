defmodule KakeguruiBankWeb.BalanceController do
  use KakeguruiBankWeb, :controller

  alias KakeguruiBank.Financial

  def index(conn, _params) do
    balance = Financial.get_balance_for_user_id!(conn.assigns.current_user.id)

    conn
    |> put_status(:ok)
    |> json(%{balance: balance})
  end
end
