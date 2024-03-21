defmodule Unlogged do
  use Ecto.Schema
  import Ecto.Changeset

  schema "unlogged" do
    field(:key, :string, primary_key: true)
    field(:value, :string)

    timestamps()
  end

  def changeset(unlogged, attrs) do
    unlogged
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
  end
end
