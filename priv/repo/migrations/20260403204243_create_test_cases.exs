defmodule Syncrojudge.Repo.Migrations.CreateTestCases do
  use Ecto.Migration

  def change do
    create table(:test_cases) do
      add(:problem_id, references(:problems, on_delete: :delete_all), null: false)
      # S3
      add(:input_path, :string, null: false)
      # gabarito
      add(:output_path, :string, null: false)
      # ordem de execução
      add(:position, :integer)
      # caso exemplo do enunciado
      add(:is_sample, :boolean, default: false)
      timestamps()
    end

    create(index(:test_cases, [:problem_id]))
  end
end
