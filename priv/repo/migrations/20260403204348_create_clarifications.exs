defmodule Syncrojudge.Repo.Migrations.CreateClarifications do
  use Ecto.Migration

  def change do
    create table(:clarifications) do
      add(:contest_id, references(:contests, on_delete: :delete_all), null: false)
      add(:team_id, references(:teams, on_delete: :delete_all), null: false)
      # nullable = dúvida geral
      add(:problem_id, references(:problems, on_delete: :delete_all))
      add(:question, :text, null: false)
      add(:answer, :text)
      # login do juiz que respondeu
      add(:answered_by, :string)
      # enviar resposta para todos os times?
      add(:broadcast, :boolean, default: false)
      add(:answered_at, :utc_datetime_usec)
      timestamps()
    end

    create(index(:clarifications, [:contest_id]))
    create(index(:clarifications, [:team_id]))
    create(index(:clarifications, [:problem_id]))
    create(index(:clarifications, [:broadcast]))
  end
end
