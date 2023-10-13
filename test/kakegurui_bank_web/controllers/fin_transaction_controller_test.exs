defmodule KakeguruiBankWeb.FinTransactionControllerTest do
  use KakeguruiBankWeb.ConnCase

  import KakeguruiBank.FinancialFixtures

  alias KakeguruiBank.Financial.FinTransaction

  @create_attrs %{
    uuid: "7488a646-e31f-11e4-aace-600308960662",
    sender_info_cpf: "some sender_info_cpf",
    receiver_info_cpf: "some receiver_info_cpf",
    amount: "120.5",
    processed_at: ~N[2023-10-12 11:26:00]
  }
  @update_attrs %{
    uuid: "7488a646-e31f-11e4-aace-600308960668",
    sender_info_cpf: "some updated sender_info_cpf",
    receiver_info_cpf: "some updated receiver_info_cpf",
    amount: "456.7",
    processed_at: ~N[2023-10-13 11:26:00]
  }
  @invalid_attrs %{uuid: nil, sender_info_cpf: nil, receiver_info_cpf: nil, amount: nil, processed_at: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all fin_transactions", %{conn: conn} do
      conn = get(conn, ~p"/api/fin_transactions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create fin_transaction" do
    test "renders fin_transaction when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/fin_transactions", fin_transaction: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/fin_transactions/#{id}")

      assert %{
               "id" => ^id,
               "amount" => "120.5",
               "processed_at" => "2023-10-12T11:26:00",
               "receiver_info_cpf" => "some receiver_info_cpf",
               "sender_info_cpf" => "some sender_info_cpf",
               "uuid" => "7488a646-e31f-11e4-aace-600308960662"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/fin_transactions", fin_transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update fin_transaction" do
    setup [:create_fin_transaction]

    test "renders fin_transaction when data is valid", %{conn: conn, fin_transaction: %FinTransaction{id: id} = fin_transaction} do
      conn = put(conn, ~p"/api/fin_transactions/#{fin_transaction}", fin_transaction: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/fin_transactions/#{id}")

      assert %{
               "id" => ^id,
               "amount" => "456.7",
               "processed_at" => "2023-10-13T11:26:00",
               "receiver_info_cpf" => "some updated receiver_info_cpf",
               "sender_info_cpf" => "some updated sender_info_cpf",
               "uuid" => "7488a646-e31f-11e4-aace-600308960668"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, fin_transaction: fin_transaction} do
      conn = put(conn, ~p"/api/fin_transactions/#{fin_transaction}", fin_transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete fin_transaction" do
    setup [:create_fin_transaction]

    test "deletes chosen fin_transaction", %{conn: conn, fin_transaction: fin_transaction} do
      conn = delete(conn, ~p"/api/fin_transactions/#{fin_transaction}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/fin_transactions/#{fin_transaction}")
      end
    end
  end

  defp create_fin_transaction(_) do
    fin_transaction = fin_transaction_fixture()
    %{fin_transaction: fin_transaction}
  end
end
