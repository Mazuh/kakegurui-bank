defmodule KakeguruiBankWeb.UserControllerTest do
  use KakeguruiBankWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      create_attrs = %{
        "cpf" => "052.490.668-87",
        "first_name" => "João",
        "last_name" => "da Silva",
        "pass" => "my secret"
      }

      conn = post(conn, ~p"/api/users", create_attrs)
      assert _ = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = %{first_name: nil, last_name: nil, cpf: nil, hash_pass: nil}
      conn = post(conn, ~p"/api/users", invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
