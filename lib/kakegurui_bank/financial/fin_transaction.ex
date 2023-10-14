defmodule KakeguruiBank.Financial.FinTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fin_transactions" do
    field :uuid, Ecto.UUID
    field :amount, :decimal
    field :processed_at, :naive_datetime
    field :sender_id, :id
    field :sender_info_cpf, :string
    field :receiver_id, :id
    field :receiver_info_cpf, :string
    field :refunded_at, :naive_datetime

    timestamps(updated_at: false)
  end

  def changeset(fin_transaction, attrs) do
    fin_transaction
    |> cast(attrs, [
      :uuid,
      :amount,
      :processed_at,
      :sender_id,
      :sender_info_cpf,
      :receiver_id,
      :receiver_info_cpf,
      :refunded_at
    ])
    |> validate_required([
      :uuid,
      :amount,
      :sender_id,
      :sender_info_cpf,
      :receiver_id,
      :receiver_info_cpf
    ])
    |> validate_number(:amount, greater_than: 0)
    |> validate_format(:sender_info_cpf, ~r/^\d{3}\.\d{3}\.\d{3}-\d{2}$/)
    |> validate_format(:receiver_info_cpf, ~r/^\d{3}\.\d{3}\.\d{3}-\d{2}$/)
  end
end
