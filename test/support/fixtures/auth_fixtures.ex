defmodule KakeguruiBank.AuthFixtures do
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
        first_name: "some first_name",
        last_name: "some last_name",
        cpf: "some cpf",
        hash_pass: "some hash_pass"
      })
      |> KakeguruiBank.Auth.create_user()

    user
  end
end
