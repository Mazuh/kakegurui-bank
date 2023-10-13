defmodule KakeguruiBankWeb.FinTransactionControllerTest do
  use KakeguruiBankWeb.ConnCase

  import KakeguruiBank.FinancialFixtures
  import KakeguruiBank.AuthFixtures

  # @invalid_attrs %{
  #   uuid: nil,
  #   sender_info_cpf: nil,
  #   receiver_info_cpf: nil,
  #   amount: nil,
  #   processed_at: nil
  # }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json") |> inject_logged_user_fixture}
  end

  describe "index" do
    test "lists all fin_transactions", %{conn: conn} do
      conn = get(conn, ~p"/api/fin_transactions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create fin_transaction" do
    test "renders fin_transaction when data is valid", %{conn: conn} do
      user_fixture(%{cpf: "111.111.111-11"})

      create_attrs = %{
        "receiver_cpf" => "111.111.111-11",
        "amount" => "1.99"
      }

      conn = post(conn, ~p"/api/fin_transactions", create_attrs)

      data = json_response(conn, 201)["data"]
      assert data["uuid"] != nil
      assert data["amount"] == "1.99"
      assert data["sender_info_cpf"] == "052.490.668-87"
      assert data["receiver_info_cpf"] == "111.111.111-11"
    end

    test "renders errors when receiver doesnt exist", %{conn: conn} do
      create_attrs = %{
        "receiver_cpf" => "111.111.111-11",
        "amount" => "1.99"
      }

      conn = post(conn, ~p"/api/fin_transactions", create_attrs)
      response = json_response(conn, 422)
      assert response["message"] == "Receiver does not exist"
    end

    test "renders errors if amount is negative", %{conn: conn} do
      user_fixture(%{cpf: "111.111.111-11"})

      create_attrs = %{
        "receiver_cpf" => "111.111.111-11",
        "amount" => "-1"
      }

      conn = post(conn, ~p"/api/fin_transactions", create_attrs)
      response = json_response(conn, 400)
      assert response["message"] == "amount: must be greater than 0;"
    end
  end
end
