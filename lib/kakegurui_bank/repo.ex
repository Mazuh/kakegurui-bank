defmodule KakeguruiBank.Repo do
  use Ecto.Repo,
    otp_app: :kakegurui_bank,
    adapter: Ecto.Adapters.Postgres
end
