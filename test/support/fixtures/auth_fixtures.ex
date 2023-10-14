defmodule KakeguruiBank.AuthFixtures do
  use KakeguruiBankWeb.ConnCase

  @moduledoc """
  This module defines test helpers for creating
  entities via the `KakeguruiBank.Auth` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        "first_name" => "João",
        "last_name" => "da Silva",
        "cpf" => "052.490.668-87",
        "pass" => "some hash_pass"
      })
      |> KakeguruiBank.Auth.create_user()

    user
  end

  def inject_logged_user_fixture(conn, attrs \\ %{}) do
    user = user_fixture(attrs)
    token = KakeguruiBank.AuthToken.sign(user.cpf)
    conn |> put_req_header("authorization", "Bearer #{token}")
  end
end
