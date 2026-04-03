defmodule Syncrojudge.Repo.Migrations.CreateProblems do
  use Ecto.Migration

  def change do
    create table(:problems) do
      add(:title, :string, null: false)
      add(:contest_id, references(:contests, on_delete: :delete_all), null: false)

      add(:label, :string, null: false)
      add(:time_limit_ms, :integer, default: 1000)
      add(:memory_limit_mb, :integer, default: 256)
      add(:pdf_path, :string)
      add(:color, :string)
      add(:position, :integer)

      timestamps()
    end

    create(unique_index(:problems, [:contest_id, :label]))
    create(index(:problems, [:contest_id]))
  end
end
