defmodule KakeguruiBank.Repo.Migrations.AddRefundedAtColToFinTransactions do
  use Ecto.Migration

  def change do
    alter table(:fin_transactions) do
      add :refunded_at, :naive_datetime
    end
  end
end
