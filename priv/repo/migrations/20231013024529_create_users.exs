defmodule KakeguruiBank.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :cpf, :string
      add :hash_pass, :string

      timestamps(updated_at: false)
    end

    create unique_index(:users, [:cpf])
  end
end
