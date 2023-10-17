defmodule KakeguruiBankWeb.AuthenticationController do
  use KakeguruiBankWeb, :controller

  def index(conn, %{"cpf" => cpf, "pass" => pass}) do
    with {:ok, _} <- KakeguruiBank.Auth.verify_user(%{"cpf" => cpf, "pass" => pass}),
         token <- KakeguruiBank.AuthToken.sign(cpf) do
      conn
      |> put_status(:ok)
      |> json(%{token: token})
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{token: "Incorrect email or password."})
    end
  end
end
