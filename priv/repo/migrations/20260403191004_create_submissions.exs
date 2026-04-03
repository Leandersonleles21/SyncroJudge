defmodule Syncrojudge.Repo.Migrations.CreateSubmissions do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add(:team_id, references(:teams, on_delete: :delete_all), null: false)
      add(:problem_id, references(:problems, on_delete: :delete_all), null: false)
      add(:contest_id, references(:contests, on_delete: :delete_all), null: false)

      # "c", "cpp", "java", "python", "kotlin"
      add(:language, :string, null: false)

      # s3://bucket/submissions/uuid.cpp
      add(:source_code_path, :string)
      # manter se quiser busca/diff no banco mesmo
      add(:source_code, :text)

      add(:status, :string, default: "pending", null: false)
      add(:result, :string)

      add(:time_used_ms, :integer)
      add(:memory_used_mb, :integer)

      add(:submitted_at, :utc_datetime_usec, null: false)
      add(:completed_at, :utc_datetime_usec)

      add(:judge_message, :text)
      add(:test_case_failed, :integer)
      add(:attempt_number, :integer)

      timestamps()
    end

    create(index(:submissions, [:contest_id, :team_id]))
    create(index(:submissions, [:contest_id, :problem_id]))
    create(index(:submissions, [:team_id, :problem_id]))
    create(index(:submissions, [:status]))
  end
end
