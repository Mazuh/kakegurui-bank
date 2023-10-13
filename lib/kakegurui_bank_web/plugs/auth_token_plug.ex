defmodule KakeguruiBankWeb.Plugs.AuthTokenPlug do
  import Plug.Conn
  require Logger

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user_cpf} <- KakeguruiBank.AuthToken.verify(token) do
      conn |> assign(:current_user, KakeguruiBank.Auth.get_user_by_cpf!(user_cpf))
    else
      _error ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.put_view(KakeguruiBankWeb.ErrorView)
        |> halt()
    end
  end
end
