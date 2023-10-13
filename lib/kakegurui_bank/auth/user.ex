defmodule KakeguruiBank.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :cpf, :string
    field :pass, :string, virtual: true
    field :hash_pass, :string
    field :initial_amount, :decimal, virtual: true

    timestamps(updated_at: false)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :cpf, :pass, :hash_pass])
    |> validate_required([:first_name, :last_name, :cpf, :pass])
    |> unique_constraint(:cpf)
    |> validate_format(:cpf, ~r/^\d{3}\.\d{3}\.\d{3}-\d{2}$/)
    |> validate_number(:initial_amount, greater_than_or_equal_to: 0)
    |> put_hash_pass()
  end

  defp put_hash_pass(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{pass: pass}} ->
        put_change(changeset, :hash_pass, Argon2.add_hash(pass).password_hash)
        |> delete_change(:pass)

      _ ->
        changeset
    end
  end
end
