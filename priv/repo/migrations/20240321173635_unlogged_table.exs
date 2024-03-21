defmodule Repo.Migrations.UnloggedTable do
  use Ecto.Migration

  def change do
    create table(:unlogged) do
      add(:key, :string)
      add(:value, :string)
      timestamps()
    end

    create(unique_index(:unlogged, [:key]))

    execute("ALTER TABLE unlogged SET UNLOGGED")
  end
end
