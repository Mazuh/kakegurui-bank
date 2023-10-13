defmodule KakeguruiBank.Repo.Migrations.CreateFinTransactions do
  use Ecto.Migration

  def change do
    create table(:fin_transactions) do
      add :uuid, :uuid
      add :amount, :decimal
      add :processed_at, :naive_datetime
      add :sender_id, references(:users, on_delete: :nothing)
      add :sender_info_cpf, :string
      add :receiver_id, references(:users, on_delete: :nothing)
      add :receiver_info_cpf, :string

      timestamps(updated_at: false)
    end

    create unique_index(:fin_transactions, [:uuid])
    create index(:fin_transactions, [:sender_id])
    create index(:fin_transactions, [:receiver_id])
  end
end
