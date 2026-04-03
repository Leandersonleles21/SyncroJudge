defmodule Syncrojudge.Repo.Migrations.CreateScoreboardEntries do
  use Ecto.Migration

  def change do
    create table(:scoreboard_entries) do
      add(:contest_id, references(:contests, on_delete: :delete_all), null: false)
      add(:team_id, references(:teams, on_delete: :delete_all), null: false)
      add(:problem_id, references(:problems, on_delete: :delete_all), null: false)

      # quantas submissões antes do accepted (penalidade)
      add(:attempts, :integer, default: 0, null: false)
      # resolveu?
      add(:solved, :boolean, default: false, null: false)
      # minuto em que acertou (relativo ao início do contest)
      add(:solved_at_minute, :integer)
      # penalidade total = solved_at_minute + (attempts * penalty_minutes)
      add(:penalty, :integer, default: 0, null: false)
      # se a solução accepted caiu no período de freeze
      add(:frozen, :boolean, default: false, null: false)
      # submissões pendentes durante freeze (o time vê "?")
      add(:pending_count, :integer, default: 0, null: false)
      # primeira submissão deste time+problema (para "first to solve")
      add(:first_submission_at, :utc_datetime_usec)

      timestamps()
    end

    # cada time tem no máximo uma entrada por problema por contest
    create(unique_index(:scoreboard_entries, [:contest_id, :team_id, :problem_id]))
    create(index(:scoreboard_entries, [:contest_id]))
    create(index(:scoreboard_entries, [:team_id]))
  end
end
