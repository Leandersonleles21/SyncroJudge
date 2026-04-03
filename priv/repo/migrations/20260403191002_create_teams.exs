defmodule Syncrojudge.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add(:name, :string, null: false)
      add(:contest_id, references(:contests, on_delete: :delete_all), null: false)

      add(:login, :string, null: false)
      add(:password_hash, :string, null: false)
      add(:enabled, :boolean, default: true)

      timestamps()
    end

    create(unique_index(:teams, [:login, :contest_id]))
    create(index(:teams, [:contest_id]))
  end
end
