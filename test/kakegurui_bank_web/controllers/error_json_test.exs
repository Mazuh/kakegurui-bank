defmodule KakeguruiBankWeb.ErrorJSONTest do
  use KakeguruiBankWeb.ConnCase, async: true

  test "renders 401" do
    assert KakeguruiBankWeb.ErrorJSON.render("401.json", %{}) == %{
             errors: %{detail: "Unauthorized"}
           }
  end

  test "renders 404" do
    assert KakeguruiBankWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert KakeguruiBankWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
