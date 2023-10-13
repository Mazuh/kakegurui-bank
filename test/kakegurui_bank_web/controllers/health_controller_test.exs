defmodule KakeguruiBankWeb.HealthControllerTest do
  use KakeguruiBankWeb.ConnCase

  test "GET /health", %{conn: conn} do
    conn = get(conn, ~p"/api/health")
    assert json_response(conn, 200) == %{"status" => "ok"}
  end
end
