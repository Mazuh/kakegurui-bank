defmodule KakeguruiBank.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :cpf, :string
    field :hash_pass, :string

    timestamps(inserted_at: true, updated_at: false)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :cpf, :hash_pass])
    |> validate_required([:first_name, :last_name, :cpf, :hash_pass])
  end
end