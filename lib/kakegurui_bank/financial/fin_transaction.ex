defmodule KakeguruiBank.Financial.FinTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fin_transactions" do
    field :uuid, Ecto.UUID
    field :sender_info_cpf, :string
    field :receiver_info_cpf, :string
    field :amount, :decimal
    field :processed_at, :naive_datetime
    field :sender_id, :id
    field :receiver_id, :id

    timestamps()
  end

  @doc false
  def changeset(fin_transaction, attrs) do
    fin_transaction
    |> cast(attrs, [:uuid, :sender_info_cpf, :receiver_info_cpf, :amount, :processed_at])
    |> validate_required([:uuid, :sender_info_cpf, :receiver_info_cpf, :amount, :processed_at])
  end
end
