defmodule Repo.Migrations.LoggedTable do
  use Ecto.Migration

  def change do
    create table(:logged) do
      add(:key, :string)
      add(:value, :string)
      timestamps()
    end

    create(unique_index(:logged, [:key]))
  end
end
