defmodule Syncrojudge.Repo.Migrations.CreateSubmissions do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add :team_id, references(:teams, on_delete: :delete_all), null: false
      add :problem_id, references(:problems, on_delete: :delete_all), null: false
      add :contest_id, references(:contests, on_delete: :delete_all), null: false
      add :language, :string
      add :source_code, :text
      add :status, :string
      add :result, :string
      add :time_used, :float
      add :memory_used, :float
      add :submitted_at, :utc_datetime_usec
      add :completed_at, :utc_datetime_usec

      timestamps()
    end
  end
end
