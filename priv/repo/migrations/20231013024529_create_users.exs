defmodule KakeguruiBank.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :cpf, :string, null: false
      add :hash_pass, :string, null: false

      timestamps(updated_at: false)
    end

    create unique_index(:users, [:cpf])
  end
end
