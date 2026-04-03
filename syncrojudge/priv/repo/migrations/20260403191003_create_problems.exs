defmodule Syncrojudge.Repo.Migrations.CreateProblems do
  use Ecto.Migration

  def change do
    create table(:problems) do
      add :title, :string, null: false
      add :description, :text
      add :contest_id, references(:contests, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:problems, [:contest_id])
  end
end
