defmodule Syncrojudge.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false
      add :contest_id, references(:contests, on_delete: :delete_all), null: false

      timestamps()
    end
    
    create index(:teams, [:contest_id])
  end
end
