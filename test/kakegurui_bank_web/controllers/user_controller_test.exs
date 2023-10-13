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
        "hash_pass" => "some hash_pass"
      }

      conn = post(conn, ~p"/api/users", create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "cpf" => "052.490.668-87",
               "first_name" => "João",
               "last_name" => "da Silva",
               "hash_pass" => "some hash_pass"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = %{first_name: nil, last_name: nil, cpf: nil, hash_pass: nil}
      conn = post(conn, ~p"/api/users", invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
