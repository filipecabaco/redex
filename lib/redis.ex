defmodule Redex do
  use Application
  require Logger
  import Ecto.Query

  def start(_type, _args) do
    port = 6379

    children = [
      Repo,
      {DynamicSupervisor, name: ConnectionSupervisor},
      {SocketConnection, %{port: port}}
    ]

    Logger.info("Accepting connections on port #{port}")
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def insert(Logged, key, value) do
    case Repo.get_by(Logged, key: key) do
      nil ->
        changeset = Logged.changeset(%Logged{}, %{key: key, value: value})
        Repo.insert(changeset)

      unlogged ->
        changeset = Unlogged.changeset(unlogged, %{value: value})
        Repo.update(changeset)
    end
  end

  def insert(_, key, value) do
    case Repo.get_by(Unlogged, key: key) do
      nil ->
        changeset = Unlogged.changeset(%Unlogged{}, %{key: key, value: value})
        Repo.insert(changeset)

      unlogged ->
        changeset = Unlogged.changeset(unlogged, %{value: value})
        Repo.update(changeset)
    end
  end

  def get(Logged, key) do
    Repo.get_by(Logged, key: key)
  end

  def get(_, key) do
    Repo.get_by(Unlogged, key: key)
  end

  def exists(Logged, key) do
    Repo.exists?(from(u in Logged, where: u.key == ^key, select: u.key))
  end

  def exists(_, key) do
    Repo.exists?(from(u in Unlogged, where: u.key == ^key, select: u.key))
  end

  def delete(Logged, key) do
    Repo.delete_all(from(u in Logged, where: u.key == ^key))
  end

  def delete(_, key) do
    Repo.delete_all(from(u in Unlogged, where: u.key == ^key))
  end
end
