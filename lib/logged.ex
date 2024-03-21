defmodule Logged do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logged" do
    field(:key, :string, primary_key: true)
    field(:value, :string)

    timestamps()
  end

  def changeset(logged, attrs) do
    logged
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
  end
end
