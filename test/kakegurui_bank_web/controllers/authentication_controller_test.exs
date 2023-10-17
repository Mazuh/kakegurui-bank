defmodule KakeguruiBankWeb.AuthenticationControllerTest do
  use KakeguruiBankWeb.ConnCase
  alias KakeguruiBank.Auth
  import KakeguruiBank.AuthFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "login" do
    test "can generate token", %{conn: conn} do
      Auth.create_user(%{
        "cpf" => "052.490.668-87",
        "first_name" => "João",
        "last_name" => "da Silva",
        "pass" => "my secret"
      })

      login_payload = %{
        "cpf" => "052.490.668-87",
        "pass" => "my secret"
      }

      conn = post(conn, ~p"/api/authentication", login_payload)
      token = json_response(conn, 200)["token"]
      assert token != nil
    end

    test "wrong password will respond with permission error", %{conn: conn} do
      Auth.create_user(%{
        "cpf" => "052.490.668-87",
        "first_name" => "João",
        "last_name" => "da Silva",
        "pass" => "my secret"
      })

      login_payload = %{
        "cpf" => "052.490.668-87",
        "pass" => "wadda wadda wadda"
      }

      conn = post(conn, ~p"/api/authentication", login_payload)
      assert conn.status == 401
    end

    test "generated token will work", %{conn: conn} do
      user = user_fixture()
      token = KakeguruiBank.AuthToken.sign(user.cpf)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      conn = get(conn, ~p"/api/authentication")
      assert json_response(conn, 200)["first_name"] == user.first_name
    end

    test "empty tokens will respond with permission error", %{conn: conn} do
      conn = get(conn, ~p"/api/authentication")
      assert conn.status == 401
    end

    test "invalid tokens will respond with permission error", %{conn: conn} do
      conn = put_req_header(conn, "authorization", "Bearer blabla.invalid.blabla")
      conn = get(conn, ~p"/api/authentication")
      assert conn.status == 401
    end
  end
end
