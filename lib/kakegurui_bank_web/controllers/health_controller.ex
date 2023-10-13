defmodule KakeguruiBankWeb.HealthController do
  use KakeguruiBankWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{status: "ok"})
  end
end
